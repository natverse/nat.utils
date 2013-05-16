context("file system utility functions")

test_that('abs2rel works',{
  testans=abs2rel("/Volumes/JData/JPeople/Sebastian/images","/Volumes/JData/JPeople/")
  realans="Sebastian/images"
  expect_equal(testans,realans)
  
  testans=abs2rel("/Volumes/JData/JPeople/Sebastian/images","/Volumes/JData/JPeople")
  realans="Sebastian/images"
  expect_equal(testans,realans)
  
  expect_error(abs2rel("/some/other/path","/Volumes/JData/JPeople/",
                       StopIfNoCommonPath=TRUE),)
  
  expect_warning(testans<-abs2rel("/some/other/path","/Volumes/JData/JPeople/"))
  realans="/some/other/path"
  expect_equal(testans,realans)
})
