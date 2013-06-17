context("zip utility functions")

test_that('can get information about sample zip file',{
      zipfile=file.path('data','sample.zip')
      r=zipinfo(zipfile)
      baseline=structure(list(Length = c("0", "25", "0", "0"), Method = c("Stored", 
                  "Stored", "Stored", "Stored"), Size = c("0", "25", "0", "0"), 
              Ratio = c("0%", "0%", "0%", "0%"), Date = c("06-17-13", "06-17-13", 
                  "06-17-13", "06-17-13"), Time = c("03:48", "03:48", "03:48", 
                  "03:48"), `CRC-32` = c("00000000", "5e61c365", "00000000", 
                  "00000000"), Name = c("sample/", "sample/README", "sample/somedir/", 
                  "sample/somedir/empty")), .Names = c("Length", "Method", 
              "Size", "Ratio", "Date", "Time", "CRC-32", "Name"), row.names = c("sample/", 
              "sample/README", "sample/somedir/", "sample/somedir/empty"), class = "data.frame")
      expect_equal(r,baseline)
    })

test_that('can get test integrity of sample zip file',{
      zipfile=file.path('data','sample.zip')
      notzipfile='test-ziputils.r'
      expect_true(zipok(zipfile))
      expect_false(zipok(notzipfile))
    })
