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
  fields=unlist(strsplit(results[2],"[ ]+"))
  fields=fields[fields!=""]
  
  dash_lines=grep('^-----',results)
  if(length(dash_lines)!=2) stop("Unable to parse zip information for file ",f)
  result_lines=seq(from=dash_lines[1]+1,to=dash_lines[2]-1)
  
  values=t(sapply(results[result_lines],function(x) unlist(strsplit(x,"[ ]+"))))
  # drop empty first column
  values=values[,-1]
  colnames(values)=fields
  rownames(values) <- x[,'Name']
  as.data.frame(values,stringsAsFactors=FALSE)
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
