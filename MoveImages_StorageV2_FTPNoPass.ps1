Import-Module PSFTP
$ProgressPreference = 'SilentlyContinue'


$ErrorActionPreference = “Stop”
    $IpAddr = "\\192.168.22.1"
    #$IpAddr = "\\localhost"
    #$IpAddr = "n:"
    #Start-Sleep -s 600
    $DatePathArray = @()
    $CamPathArray = @()
    $FTPUsername = 'admin'
    $FTPPassword = 'password'
    $FolderName = 'Dahua'
    #$FolderName = 'CameraTemp'

    $FTPSecurePassword = ConvertTo-SecureString -String $FTPPassword -asPlainText -Force
    $FTPCredential = New-Object System.Management.Automation.PSCredential($FTPUsername,$FTPSecurePassword)
    Set-FTPConnection -Credentials $FTPCredential -Server ftp://192.168.22.1 -Session MyFTPSession -KeepAlive -UsePassive
    $Session = Get-FTPConnection -Session MyFTPSession

    $filewasprocessed = 1
    $foldwasprocessed = 1

    for ($loops = 0; ($loops -lt 10) -and ($foldwasprocessed -eq 1); $loops++)
    {
        $filewasprocessed = 0
        $foldwasprocessed = 0
        $DatePathArray = @()
        $CamPathArray = @()
        try{
                Write-Host "Starting Loop" 
                Get-FTPChildItem -Session $Session -Path $FolderName| Sort-Object -Property Name | ForEach-Object {
                #Get-ChildItem -Path "$IpAddr\Dahua"| ?{ $_.PSIsContainer } | Sort-Object| ForEach-Object {
                    #Write-Host $_.Name 
                    $CamPath = $_.Name



                    #if(1)#($CamPath -like "Quintal" )#-or $CamPath -like "Garagem")) # ************ Filter ************
                    #if(($CamPath -like "Quintal") -or $CamPath -like "Garagem") # ************ Filter ************
                    #if($CamPath -like "Garagem" -or $CamPath -like "Rua2") # ************ Filter ************
                    #if($CamPath -like "Garagem")# -or $CamPath -like "Rua2") # ************ Filter ************
                    #if($CamPath -like "1F01243PAU00592")#
                    #if($CamPath -like "Rua2" -or $CamPath -like "1F01243PAU00592" -or $CamPath -like "Rua1" -or $CamPath -like "Quintal" -or $CamPath -like "Garagem")# ************ Filter ************
                    if($CamPath -like "Rua2" -or $CamPath -like "1F01243PAU00592" -or $CamPath -like "Rua1" -or $CamPath -like "Garagem")# ************ Filter ************
                    #if($CamPath -like "Rua2" -or $CamPath -like "1F01243PAU00592" -or $CamPath -like "Garagem")# ************ Filter ************
                    #if($CamPath -like "Rua2" -or $CamPath -like "1F01243PAU00592") # ************ Filter ************
                    {    
                        $CamPathArray += $CamPath
                        #Write-Host "Getting Path"
                        Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath"| Sort-Object -Property Name | ForEach-Object {          
                            #Write-Host $_.Name
                            $DatePath = $_.Name
                            if(!($DatePath -like "DVRWorkDirectory"))
                            {

                                #Write-Host $_.FullName
                                $string = Split-Path $_.FullName
                                #Write-Host $string.Split("\")
                                $CamFolder =  $string.Split("\")[4]
                                $DateFolder =  $string.Split("\")[5]
                                $DateYear = $_.Name.Split("-")[0]
                                $DateMonth = $_.Name.Split("-")[1]
                                $DateDay = $_.Name.Split("-")[2]
                                $DateYearMonth = $_.Name.Split("-")[0] + "-" + $_.Name.Split("-")[1]
                                $DateYearDay = [datetime]::parse($_.Name.Split("-")[0] + "-" + $_.Name.Split("-")[1] + "-" + $_.Name.Split("-")[2])
                                #Write-Host "$($_.LastWriteTime.Year)_$($_.LastWriteTime.Month)_$($_.LastWriteTime.Day)_$($_.LastWriteTime.Hour)_$($_.LastWriteTime.Minute)_$($_.BaseName)$($_.Extension)"
                            
                                ##### Last Done Date
                                $Doneuntil = [datetime]::parse("2023-02-10") #############
                                #####
                                if($DateYearDay -gt $Doneuntil)
                                {
                                    #if(1)
                                    if(!($DatePath -like "2023-03-31"))# -and ($DateDay -like "2017-05-10")) # ************ Filter ************
                                    #if($DatePath -like "2022-12-21") #-or
                                    #   ($DatePath -like "2022-04-12") -or # ************ Filter ************
                                    #   ($DatePath -like "2022-04-11") -or # ************ Filter ************
                                    #   ($DatePath -like "2022-04-10") -or # ************ Filter ************
                                    #   ($DatePath -like "2022-04-18")) # ************ Filter ************
                                    #if(($DatePath -like "2022-02-16"))# ************ Filter ************
                                    {
                                        $DatePathArray += $_.Name

                                    }
                                }
                            }
                        }
                    }

                }

                #$DatePathArray2 = $DatePathArray | Sort-Object -Descending -Unique # ************ Filter ************
                $DatePathArray2 = $DatePathArray | Sort-Object -Unique # ************ Filter ************
                Write-Host "xxxxxxxxx"
                Write-Host $CamPathArray
                Write-Host "xxxxxxxxx"
                Write-Host $DatePathArray2
                Write-Host "xxxxxxxxx"

                Write-Host " ** Start **"

                ForEach($DatePath in $DatePathArray2){
                    Write-Host "Processing -- $DatePath" -ForegroundColor Yellow
                    ForEach($CamPath in $CamPathArray){
                        #Write-Host "***"
                        Write-Host "Processing -- $CamPath" -ForegroundColor Green
                        Start-Sleep -s 0.2
                        #Write-Host "***"
                        switch ($CamPath)
                        { 
                            Rua1 
                                {
                                    $folderletter = "A"
                                    $division = "Rua"
                                }
                            1F01243PAU00592 
                                {
                                    $folderletter = "C"
                                    $division = "Rua"
                                }
                            Garagem
                                {
                                    $folderletter = "G"
                                    $division = "Interno"
                                }
                            Quintal
                                {
                                    $folderletter = "Q"
                                    $division = "Interno"
                                }
                            Rua2
                                {
                                    $folderletter = "B"
                                    $division = "Rua"
                                }
                            default
                                {
                                    $folderletter = "A"
                                    $division = "Rua"
                                }
                        }


                        #Write-Host "****"
                        #Write-Host "$IpAddr\$FolderName\$CamPath\$DatePath\001\jpg"
                        #if(Test-Path "$IpAddr\$FolderName\$CamPath\$DatePath\001\jpg"){
                            #Write-Host  $(Get-Item "$IpAddr\$FolderName\$CamPath\$DatePath\001\jpg").FullName
                            $DateYear = $DatePath.Split("-")[0]
                            $DateMonth = $DatePath.Split("-")[1]
                            $DateDay = $DatePath.Split("-")[2]
                            $DateYearMonth = $DatePath.Split("-")[0] + "-" + $DatePath.Split("-")[1]
                            #Write-Host $DateYear
                            #Write-Host $DateMonth
                            #Write-Host $DateDay
                            #Write-Host $DateYearMonth

                            #Write-Host "Processing -" $_.Name
                            $TestPath = 1
                            try {
                                #Write-Host "Folder: $DatePath/001/jpg" 
                                Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg"| ForEach-Object {          
                                #Write-Host "Folder: /$FolderName/$CamPath/$DatePath/001/jpg" 
                                #Write-Host "Folder $_.FullName"
                                $HourPath = $_.Name
                            #}
                                #Write-Host $_.Name 
    
                                if(1) # ************ Filter ************
                                #if(($HourPath -eq "04")) # -or $HourPath -like "12")) # ************ Filter ************
                                #if(($HourPath -eq "15") -or ($HourPath -eq "15")) # -or $HourPath -like "12")) # ************ Filter ************
                                #if(($HourPath -gt "19") -and ($HourPath -lt "24")) # ************ Filter ************
                                #if(($HourPath -gt "06") -and ($HourPath -lt "08")) # ************ Filter ************
                                #if(($HourPath -lt "20"))# -or ($HourPath -eq "08") -or ($HourPath -eq "09") -or ($HourPath -eq "12") -or ($HourPath -eq "17") -or ($HourPath -eq "18")) # ************ Filter ************
                                #if(($HourPath -eq "08") -or ($HourPath -eq "10") -or ($HourPath -eq "12") -or ($HourPath -eq "17")) # ************ Filter ************
                                #if(($HourPath -gt "13") -and ($HourPath -lt "20")) # ************ Filter ************
                                {

                                    #Write-Host $_.FullName 
                                    #Write-Host "Get Videos From: $IpAddr\$FolderName\$CamPath\$DatePath"
                                    Write-Host -NoNewline "Hour $HourPath - Minutes: " -ForegroundColor Green
                                    $printline = 1
                                    $foldwasprocessed = 1
                                    Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath" | ForEach-Object {          
                                        #Write-Host "Folder" 
                                        #Write-Host $_.FullName 
                                        $MinutePath = $_.Name
                                        if ($printline -gt 33)
                                        {
                                            Write-Host "-$MinutePath"
                                            $printline = 1
                                            
                                        }else
                                        {
                                            Write-Host -NoNewline "-$MinutePath"
                                        }
                                        $printline = $printline + 1
                                        #Write-Host $_.Name 
                                        if(1) # ************ Filter ************
                                        #if(($MinutePath -eq "24")) # -or $MinutePath -like "12")) # ************ Filter ************
                                        {
                                            #Write-Host "____Processing____" 
                                            #Write-Host "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath/$MinutePath"
                                            #Write-Host "__________________" 
                                            Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath/$MinutePath" -Filter "*.jpg" | ForEach-Object -Parallel{     
                                                Import-Module PSFTP

                                                #$FTPCredential = $using:FTPCredential
                                                #Set-FTPConnection -Credentials $FTPCredential -Server ftp://192.168.2.1 -Session MyFTPSession -UsePassive
                                                $filewasprocessed = 1
                                                $MyFTPSession = $using:MyFTPSession

                                                $Session = Get-FTPConnection -Session MyFTPSession
                                                $division = $using:division
                                                $CamPath = $using:CamPath
                                                $DateYearMonth = $using:DateYearMonth
                                                $DatePath = $using:DatePath
                                                $HourPath = $using:HourPath
                                                $MinutePath = $using:MinutePath
                                                $folderletter = $using:folderletter
                                                #$Session = Get-FTPConnection -Session MyFTPSession
                                                #Write-Host $division
                                                #Write-Host $division
                                            
                                                if($TestPath = 1)
                                                {
                                                    #Write-Host "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath"
                                                    #Start-Sleep -s 1
                                                    if(!(Test-Path "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath")){
                                                        New-Item -ItemType directory -Path "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath"
                                                    }
                                                    $TestPath = 0
                                                }
                                                #$MsTimeStart = (get-date).Second
                                                #Write-Host $_.FullName
                                            
                                                #Write-Host "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath\$DatePath-$HourPath-$MinutePath-$($_.BaseName.subString(0,$_.BaseName.length-8))[$folderletter]$($_.Extension)"
                                                #Write-Host $_.Name.subString(11,1)
                                                #Start-Sleep -s 10
                                                if ($_.Name.subString(11,1) -eq "0")
                                                {
                                                    #Write-Host $_.FullName
                                                    #Write-Host "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath\$DatePath-$HourPath-$MinutePath-$($_.Name.subString(0,$_.Name.length-12))[$folderletter].jpg"
                                                    #Start-Sleep -s 1
                                                    $result = Get-FTPItem -Session $Session -Path $_.FullName -LocalPath "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath\$DatePath-$HourPath-$MinutePath-$($_.Name.subString(0,$_.Name.length-12))[$folderletter].jpg"
                                                    #Start-Sleep -s 1
                                                    #Move-Item -Force -LiteralPath $_.FullName "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath\$DatePath-$HourPath-$MinutePath-$($_.BaseName.subString(0,$_.BaseName.length-8))[$folderletter]$($_.Extension)"
                                                    if ($result.subString(0,3) -eq "226"){
                                                        $remove_result = Remove-FTPItem -Session $Session -Path $_.FullName
                                                    }
                                                }
                                            
                                                else
                                                {
                                                    $BS = $_.Name.subString(11,1)
                                                    #Move-Item  -Force -LiteralPath $_.FullName                          "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath\$DatePath-$HourPath-$MinutePath-$($_.Name.subString(0,$_.Name.length-12))[$folderletter]$($_.BaseName.subString(11,1))$($_.Extension)"
                                                    $result = Get-FTPItem -Session $Session -Path $_.FullName -LocalPath "V:\_Camera\Images\$division\$CamPath\$DateYearMonth\$DatePath\$DatePath-$HourPath-$MinutePath-$($_.Name.subString(0,$_.Name.length-12))[$folderletter]$($_.Name.subString(11,1)).jpg"
                                                    if ($result.subString(0,3) -eq "226"){
                                                        $remove_result = Remove-FTPItem -Session $Session -Path $_.FullName
                                                    }
                                                    #Start-Sleep -s 5

                                                }
                                                #$MsTimeEnd = (get-date).Second
                                                #Write-Host $($MsTimeEnd - $MsTimeStart)
                                            } -ThrottleLimit 5
                                        }
                                    }
                                    #Write-Host "**********"
                                    Write-Host "."
                                    Write-Host "Clean"
                                    #Write-Host "**********"
                                    #Write-Host "**********"
                                    #Write-Host "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath"
                                    Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath" | ForEach-Object -Parallel{          
                                        #Write-Host $_
                                        Import-Module PSFTP
                                        $MyFTPSession = $using:MyFTPSession

                                        $Session = Get-FTPConnection -Session MyFTPSession
                                        $division = $using:division
                                        $CamPath = $using:CamPath
                                        $DateYearMonth = $using:DateYearMonth
                                        $DatePath = $using:DatePath
                                        $HourPath = $using:HourPath
                                        $folderletter = $using:folderletter
                                        $FolderName = $using:FolderName
                                        $MinutePath = $_.Name
                                        #Write-Host $_.Name 
                                        $canBeDeleted = $true
                                        #Write-Host "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath/$MinutePath"
                                        Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath/$MinutePath"  | ForEach-Object {     
                                        #$canBeDeleted = $false
                                        }
                                        #Write-Host $canBeDeleted
                                        if($canBeDeleted){
                                            $remove_result = Remove-FTPItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath/$MinutePath"
                                            #Start-Sleep -s 5
                                        }
                            
                                    }
                                    #Write-Host "**********"
                                    #Write-Host "***END****"
                                    #Start-Sleep -s 5
    #                                Get-ChildItem -Path "$IpAddr\$FolderName\$CamPath\$DatePath\001\jpg\$HourPath" -Directory -Recurse | ForEach-Object {          
    #                                    $ItemNumber = $_.GetFileSystemInfos().Count
    #                                    if($ItemNumber -eq 0)
    #                                    {
    #                                        $FolderNametoRemove = $_.fullName
    #                                        write-host "Removing Folder $FolderNametoRemove" 
    #                                        Remove-Item $FolderNametoRemove
    #                                    }
    #                                }
                                }
                                $canBeDeleted = $true
                                Get-FTPChildItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath" | ForEach-Object {          
                                    $canBeDeleted = $false
                                }
                                if($canBeDeleted){
                                    #Write-Host "**********"
                                    #Write-Host "*** Will remove Hour ****"
                                    Write-Host  "Removing: /$FolderName/$CamPath/$DatePath/001/jpg/$HourPath"
                                    #Start-Sleep -s 2
                                    $remove_result = Remove-FTPItem -Session $Session -Path "/$FolderName/$CamPath/$DatePath/001/jpg/$HourPath"
                                    #Start-Sleep -s 2
                                }
                            
                            #Write-Host "**Cycle**" -ForegroundColor Green
                            
                            #Write-Host $string.Split("\")
                            #Write-Host "$($_.ModifiedDate.Year)_$($_.ModifiedDate.Month)_$($_.ModifiedDate.Day)_$($_.ModifiedDate.Hour)_$($_.ModifiedDate.Minute)_$($_.Name)$($_.Extension)"
                            #Write-Host "$($_.ModifiedDate.Year)_$($_.ModifiedDate.Month)_$($_.ModifiedDate.Day)_$($_.ModifiedDate.Hour)_$($_.ModifiedDate.Minute)_$($_.Name).jpg"
                            }
                        }
                        catch 
                        {
                            Write-Host "Error on folder $IpAddr\$FolderName\$CamPath\$DatePath\001\jpg" -ForegroundColor Red
                            Start-Sleep -s 5
                        }

                      #} #if exist

                    # fOREACH DO CamPath

                    }
                #}
            }
        }
        catch
        {
            write-host “Caught an exception:” -ForegroundColor Red
            write-host “Exception Type: $($_.Exception.GetType().FullName)” -ForegroundColor Red
            write-host “Exception Message: $($_.Exception.Message)” -ForegroundColor Red
            #Write-Host "*** Error - Sleep ***" 
            Start-Sleep -s 10

        }
        write-host $filewasprocessed
        write-host $foldwasprocessed
        write-host “Main loop end” -ForegroundColor Green
        Start-Sleep -s 2
    }
