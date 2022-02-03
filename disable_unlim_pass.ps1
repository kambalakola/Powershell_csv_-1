Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear(); Clear-Host

cls
Import-Module ActiveDirectory;

$CSV_File_To_Import = 'C:\Share\Scripts\disable_unlim_pass\disable_unlim_Pass_test.csv'
$CSV_File_To_export = 'C:\Share\Scripts\disable_unlim_pass\disable_unlim_Pass_test_temp.csv'

$delimetr = ";"#(Get-Culture).TextInfo.ListSeparator

$csvfile = Import-csv -Delimiter $delimetr $CSV_File_To_Import
$i=0

foreach($line in $csvfile)
{

 if($i -eq 25) {continue}
if($line.status -eq "PasswordNeverExpires_OFF")
    {
    write-host $line.login
    continue

    }
if($line.status -notlike "PasswordNeverExpires_OFF" -and $i -le 25)
    {
    
    Set-ADUser -Identity $line.login -PasswordNeverExpires:$false -EA Stop
    
    $line.status = "PasswordNeverExpires_OFF"}
    $i=$i+1
   
    
    }
   
$csvfile  |Export-Csv -Delimiter $delimetr $CSV_File_To_export -NoTypeInformation
Remove-Item -Path $CSV_File_To_Import
Rename-Item -Path $CSV_File_To_export -NewName $CSV_File_To_Import

   
