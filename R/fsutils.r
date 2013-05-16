#' Make hardlink to file
#' 
#' Uses system call to access 'ln' command line utility
#' @param from Source file
#' @param to (New) target hardlink file to create
#' @param DryRun Just say what would happen
#' @param Force Overwrite target file if it exists
#' @return logical indicating success
#' @author jefferis
#' @export
#' @seealso \code{\link{file.symlink}}
file.hardlink=function(from,to,DryRun=FALSE,Force=FALSE){
  if(length(to)>1) stop("can only have one target")
  # fix any paths using e.g. ~ for home dir - necessary because we will 
  # quote the paths later on which will prevent the shell from expanding them
  to=path.expand(to);from=path.expand(from)
  # handle multiple froms
  if(length(from)>1){
    if(!file.info(".")$isdir) stop("target (to) must be a directory for multiple sources (from)")
    from=paste(shQuote(from),collapse=" ")
  } else from = shQuote(from)
  # FIXME This is not very clever
  if(nchar(from)>20000) stop("Shell command length exceeded!")
  cmd=paste("ln",ifelse(Force,"-f",""),from,shQuote(to))
  if(DryRun) cat("I would run:",cmd,"\n")
  else system(cmd)==0
}

#' Swap names of two files (by renaming first to a temporary file)
#' @param f1,f2 Paths to files
#' @return logical indicating success
#' @author jefferis
#' @export
#' @seealso \code{\link{file.rename}}
file.swap<-function(f1,f2){
  # quick function to swap filenames 
  if(length(f1)>1 || length(f2)>1) return(mapply(file.swap,f1,f2))
  
  if(!all(file.exists(f1),file.exists(f2))) stop("f1 and f2 must exist")
  
  tmpfile=tempfile(basename(f1),dirname(f1))
  rval=file.rename(from=f1,to=tmpfile) && file.rename(from=f2,to=f1) && file.rename(from=tmpfile,to=f2)
  return(rval)
}

#' Remove common part of two paths, leaving relative path
#' @param path Path to make relative
#' @param stempath Root to which \code{path} will be made relative
#' @param StopIfNoCommonPath Error if no path in common
#' @return Character vector containing relative path
#' @author jefferis
#' @export
#' @seealso \code{\link{path.expand}, \link{normalizePath}}
#' @examples
#' path = "/Volumes/JData/JPeople/Sebastian/images"
#' abs2rel(path,'/Volumes/JData')
abs2rel<-function(path,stempath=getwd(),StopIfNoCommonPath=FALSE){
  path=path.expand(path)
  stempath=path.expand(stempath)
  ncsp=nchar(stempath)
  fsep=.Platform$file.sep
  if(substr(stempath,ncsp,ncsp)!=fsep){
    stempath=paste(stempath,fsep,sep='')
  }
  
  relpath=sub(stempath,"",path,fixed=TRUE)
  
  warnorstopfun=if(StopIfNoCommonPath) stop else warning
  if(relpath==path)
    warnorstopfun("stempath: ",stempath,"is not present in: ",path)
  
  relpath
}

#' Use unix touch utility to change file's timestamp
#' 
#' If neither a time or a reference file is provided then the current time is 
#' used. If the file does not already exist, it is created unless Create=FALSE.  
#' @param file Path to file to modify
#' @param time Absolute time in POSIXct format
#' @param reference Path to a reference file
#' @param timestoupdate "access" or "modification" (default both)
#' @param Create Logical indicating whether to create file (default TRUE)
#' @return TRUE or FALSE according to success
#' @author jefferis
#' @export
touch<-function(file,time,reference,timestoupdate=c("access","modification"),
    Create=TRUE){
  if(.Platform$OS.type!="unix") {
    warning("touch relies on the existence of a system touch command")
    return(FALSE)
  }
  if(!Create && !file.exists(file)) stop("Create=F and ",file," does not exist") 
  if(!missing(time) && !missing(reference))
    stop("Please supply either a time or a reference file but not both")
  args=paste("-",substr(timestoupdate,1,1),sep="")
  if(!missing(time)){
    if(!is.character(time)) time=strftime(time,"%Y%m%d%H%M.%S")
    args=c(args,"-t",time)
  } else if(missing(reference)) {
    # use current time
  } else {
    # use reference file to supply time
    if(!file.exists(reference)) stop("reference file: ",reference," missing")
    args=c(args,"-r",shQuote(reference))
  }
  
  cmd=paste("touch",paste(args,collapse=" "),shQuote(file))
  return(system(cmd)==0)
}