library(shiny)
library(ggplot2)
library(DT)


function(input, output, session) {
    
    ### SETUP ###
    data = reactive({
        x = read.csv("./Data/diabetes.csv")
        x$Outcome <- factor(make.names(x$Outcome))
        return(x)
    })
    
    ### EXPLORE ###
    
    # Plotting scatter plot
    output$explore_plot <- renderPlot({
        ggplot(data(), aes(x=data()[,input$explore_x], y=data()[,input$explore_y], color=Outcome)) + 
            geom_point() + 
            ylab(input$explore_y) +
            xlab(input$explore_x) +
            ggtitle(paste('Outcome by', input$explore_x, 'and', input$explore_y))
    })
    
    output$DefineTarget = renderText({
        'Outcome definition:\nX1 = Positive for Diabetes\nX0 = Negative for Diabetes'
    })
    
    ### DATA PREP ###
    
    # Training Data
    train_data = reactive({
        set.seed(0)
        sample = sample.split(data()$Outcome, SplitRatio=input$prep_trainPct)
        train = subset(data(), sample == TRUE)
        
        # replace 0s with mean
        train[,input$replace_0_columns][train[,input$replace_0_columns] == 0] <- NA
        train = imputeTS::na_mean(train)
        
        train2 = train[c(input$columns, 'Outcome')]
        return(train2)
    })
    
    # Testing Data
    test_data = reactive({
        set.seed(0)
        sample = sample.split(data()$Outcome, SplitRatio=input$prep_trainPct)
        test  = subset(data(), sample == FALSE)
        
        # replace 0s with mean
        test[,input$replace_0_columns][test[,input$replace_0_columns] == 0] <- NA
        test = imputeTS::na_mean(test)
        
        test2 = test[c(input$columns, 'Outcome')]
        return(test2)
    })
    
    # Preview Data
    output$prep_view_data = DT::renderDataTable({
        if (input$view_train_test == 'Train') {
            DT::datatable(train_data())
        } else {
            DT::datatable(test_data())
        }
        
    })
    
    
    
    ### MODELING ###
    model = reactive({
        fitControl = trainControl(method = "cv",
                                  number = input$cv_number,
                                  classProbs = TRUE,
                                  summaryFunction = twoClassSummary)
        model = train(Outcome~.,
                      train_data(),
                      method="glm",
                      metric="ROC",
                      tuneLength=10,
                      preProcess = input$preprocess,
                      trControl=fitControl)
    })
    
    # Show model
    output$model_output = renderPrint({
        summary(model())
    })
    
    # Show confusion matrix
    output$confusion_matrix = renderTable({
        pred_glm = predict(model(), test_data())
        cm_glm = confusionMatrix(pred_glm, test_data()$Outcome, positive="X1")
        cm_glm$byClass[c('Sensitivity', 'Specificity', 'F1')]},
        rownames=T, colnames=F
        )
    
    # Plot ROC
    output$plot_roc = renderPlot({
        pred_prob_glm <- predict(model(), test_data(), type="prob")
        rx = roc(test_data()$Outcome, pred_prob_glm$X1)
        ggplot() + geom_line(aes(y = rx$sensitivities, x = 1 - rx$specificities), stat="identity") + ylab('Sensitivity') + xlab('1-Specificity') + ggtitle('ROC')
    })

}
