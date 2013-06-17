#' Return information about a zip archive using system unzip command
#' 
#' @details Uses system unzip command.
#' @param f Path to one (or more) files
#' @return dataframe of information
#' @family ziputils
#' @author jefferis
#' @export
#' @seealso \code{\link{zip}}
zipinfo<-function(f){
  if(length(f)>1) return(sapply(f,zipinfo))
  results=system2(command="unzip",args=c("-lv",f),stdout=TRUE)
  
  dash_lines=grep('^-----',results)
  if(length(dash_lines)!=2) stop("Unable to parse zip information for file ",f)
  result_lines=seq(from=dash_lines[1]+1,to=dash_lines[2]-1)
  
  selresults=results[c(2,result_lines)]
  # remove initial spaces
  selresults=sub("^[ ]+",'',selresults)
  # convert intervening spaces to tabs
  selresults=gsub("[ ]+",'\t',selresults)
  read.table(text=selresults,header=T,colClasses=c(Method='factor'),as.is=TRUE)
}

#' Verify integrity of one or more zip files
#' 
#' @details Uses system unzip command.
#' @param f Path to one (or more) files
#' @param Verbose Whether to be Verbose (default FALSE)
#' @return TRUE when file OK, FALSE otherwise
#' @author jefferis
#' @export
#' @family ziputils
zipok<-function(f,Verbose=FALSE){
  if(length(f)>1) return(sapply(f,zipinfo,Verbose=Verbose))
  result=system2(command="unzip",args=c("-t",f),stdout=ifelse(Verbose,"",FALSE))
  result==0
}
