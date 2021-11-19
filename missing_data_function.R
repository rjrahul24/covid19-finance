# This is a function to plot missing data from any data set
missing_data_function <- function(data, percent=FALSE)
{
  missing_patterns <- data.frame(is.na(data)) %>%
    group_by_all() %>%
    count(name = "count", sort = TRUE) %>%
    ungroup()
  if(percent)
  {
    missing_patterns <- missing_patterns %>%
      mutate(count=count/sum(count)*100)
  }
  
  # Variable to store the sorting based on initial data points
  sort_data <- names(sort(colSums(is.na(data)), decreasing = TRUE))
  
  # Modifying the data for the main plot
  data_new <- missing_patterns %>% 
    subset(select=-count)
  
  id <- which(rowSums(data_new)==0)
  row <- nrow(data_new)
  col <- ncol(data_new)
  
  data_new <- data_new %>% 
    mutate(ID = rownames(.)) %>%
    melt(id.vars=c("ID")) %>%
    mutate(missing = ifelse(ID == id,2,ifelse(value == "TRUE", 1, 0)))
  
  # The main center plot
  plot_one <- ggplot(data_new, aes(x=factor(variable,levels=sort_data), 
                                   y=factor(ID,rev(unique(ID))))) + 
    geom_tile(aes(fill=factor(missing)),color = "white") + 
    scale_fill_manual(values = alpha(c("grey", "blueviolet","grey"), c(.4,.4,0.9))) + 
    geom_text(aes(x=(1+col)/2,y=row-id+1), label = "complete cases") + 
    xlab('variable') + 
    ylab('missing pattern') + 
    guides(fill='none') + 
    theme_classic() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
  # Preparing data for the rowcounts plot
  plot_two <- ggplot(missing_patterns, aes(x=factor(rownames(missing_patterns), rev(rownames(missing_patterns))), y=count)) + 
    geom_bar(stat='identity', fill=ifelse(rownames(missing_patterns)==id, 'cornflowerblue', alpha('cornflowerblue',0.5))) + 
    xlab('') + 
    ylab(ifelse(percent,'%rows','row count')) + 
    theme_bw() + 
    theme(panel.grid.major.y=element_blank()) + 
    coord_flip()
  
  if(percent)
  {
    plot_two<-plot_two+ylim(0,100)
  }
  
  # Preparing data for the topmost plot
  df_three <- data.frame(colSums(is.na(data)))
  colnames(df_three) <- 'count'
  
  if(percent)
  {
    df_three <- df_three%>%mutate(count=count/nrow(data)*100)
  }
  
  plot_three <- ggplot(df_three,aes(x=factor(rownames(df_three),
                                             levels=sort_data), y=count)) +
    geom_bar(stat='identity',fill=alpha('cornflowerblue',0.5)) +
    ggtitle('missing value patterns') +
    theme_bw() +
    theme(panel.grid.major.x=element_blank()) +
    xlab('') +
    ylab(ifelse(percent,'%rows missing','num rows missing')) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
  if(percent)
  {
    plot_three<-plot_three + ylim(0,100)
  }
  
  design <- "
              111#
              2223
              2223
              2223
                    "
  plot_three+plot_one+plot_two+plot_layout(design=design)
}