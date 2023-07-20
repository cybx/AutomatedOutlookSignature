<#
.SYNOPSIS
  Dynamic Outlook Signature Creation - https://github.com/captainqwerty/AutomatedOutlookSignature
.DESCRIPTION
  This script uses properties from ActiveDirectory to populate the .htm and .txt file which are then stored in the $folderlocation with the name $filename.htm and $filename.txt. 
  The script can be ran as either a scheduled task at logon or preferably a Group Policy Logon script, more details on this can be found in the GitHub ReadMe.
  The script uses if statements to ensure if a user, for example, doesn't have a mobile number then that entire section of the signature is not uncluded, this makes the signature look much more professional and 
  if the user is given a mobile number, at next logon it will be added to their signature. 
  The script can also add additional parts based on group membership, the example given in this script is being a member of IT Staff adds Helpdesk contact information. 
.INPUTS
  Several properties for the user are taken directly from Active Directory, for more details on this please see the ReadMe on GitHub.
.OUTPUTS
  $folderlocation\$filename.htm - HTML signature for rich text emails
  $folderlocation\$filename.txt - Text signautre for none rich text emails
.NOTES
  Version:        4.0
  Author:         CaptainQwerty
  Modified:       24/04/2023
#>

# Attempt to get the user from Active Directory, if no user is found or there is an issue the script will exit
try {
  $user = (([adsisearcher]"(&(objectCategory=User)(samaccountname=$env:username))").FindOne().Properties)
} catch {
  Write-Host "Error: Unable to query Active Directory for user information. Details: $($_.Exception.Message)"
  exit
}

# Create the signatures folder and sets the name of the signature file
$folderLocation = Join-Path -Path $Env:appdata -ChildPath 'Microsoft\signatures'
$filename = 'Signature'
$file  = Join-Path -Path $folderLocation -ChildPath $filename

# If the folder does not exist create it
if (-not (Test-Path -Path $folderLocation)) {
  try {
      New-Item -ItemType directory -Path $folderLocation
  } catch {
      Write-Host "Error: Unable to create the signatures folder. Details: $($_.Exception.Message)"
      exit
  }
}

# Get the users properties (These should always be in Active Directory and Unique)
if($user.name.count -gt 0){$displayName = $user.name[0]} # Display Name
if($user.title.count -gt 0){$jobTitle = $user.title[0]} # Job Title
if($user.mail.count -gt 0){$email = $user.mail[0]} # Email Address

if($user.mobile.count -gt 0){$mobileNumber = $user.mobile[0]} # Mobile number
if($user.homephone.count -gt 0){$directDial = $user.homephone[0]} # Home number
if($user.telephonenumber.count -gt 0){$telephone = $user.telephonenumber[0]} # Office number

# Company name and website
if($user.company.count -gt 0){$companyName = $user.company[0]} # Company name
if($user.wwwhomepage.count -gt 0){$website = $user.wwwhomepage[0]} # Webpage address

# Address
if($user.postofficebox.count -gt 0){$poBox = $user.postofficebox[0]} # PO box number
if($user.physicaldeliveryofficename.count -gt 0){$office = $user.physicaldeliveryofficename} # Office Name
if($user.streetaddress.count -gt 0){$street = $user.streetaddress[0]} # Street address
if($user.l.count -gt 0){$city = $user.l[0]} # City
if($user.st.count -gt 0){$state = $user.st[0]} # State
if($user.postalcode.count -gt 0){$zipCode = $user.postalcode[0]} # Post code / Zip code

# Extended attributes
if($user.extensionAttribute1.count -gt 0){$attribute1 = $user.extensionAttribute1[0]} # Custom attribute 1
if($user.extensionAttribute2.count -gt 0){$attribute2 = $user.extensionAttribute2[0]} # Custom attribute 2
if($user.extensionAttribute3.count -gt 0){$attribute3 = $user.extensionAttribute3[0]} # Custom attribute 3
if($user.extensionAttribute4.count -gt 0){$attribute4 = $user.extensionAttribute4[0]} # Custom attribute 4
if($user.extensionAttribute5.count -gt 0){$attribute5 = $user.extensionAttribute5[0]} # Custom attribute 5

# Group Check Example
#$Group = [ADSI]"LDAP://cn=IT Staff,OU=Groups,DC=Example,DC=co,DC=uk"
#$Group.Member | ForEach-Object {
#if ($user.distinguishedname -match $_) {
#      $ItStaff = $true
#    }
#}

# Building Style Sheet
<#$style = 
@"
<style>
p, table, td, tr, a, span { 
    font-family: Arial, Helvetica, sans-serif;
    font-size:  12pt;
    color: #28b8ce;
}

span.blue
{
    color: #28b8ce;
}

table {
    margin: 0;
    padding: 0;
}

a { 
text-decoration: none;
}

hr {
border: none;
height: 1px;
background-color: #28b8ce;
color: #28b8ce;
width: 700px;
}

table.main {
    border-top: 1px solid #28b8ce;
}
</style>
"@

# Building HTML
<#$signature = 
@"
  $(if($displayName){"<span><b>"+$displayName+"</b></span><br />"})
  $(if($jobTitle){"<span>"+$jobTitle+"</span><br /><br />"})

<p>
  <table class='main'>
      <tr>
          <td style='padding-right: 75px;'>$(if($logo){"<img src='$logo' />"})</td>
          <td>
              <table>
                  <tr><td colspan='2' style='padding-bottom: 10px;'>
                    $(if($companyName){ "<b>"+$companyName+"</b><br />" })
                    $(if($street){ $street+", " })
                    $(if($city){ $city+", " })
                    $(if($state){ $state+", " })
                    $(if($zipCode){ $zipCode })
                  </td></tr>
                  $(if($ITMember){"<tr><td td colspan='2'>IT Helpdesk: 0188887 55555 6666</tr></td>"})
                  $(if($telephone){"<tr><td>T: </td><td><a href='tel:$telephone'>$($telephone)</a></td></tr>"})
                  $(if($mobileNumber){"<tr><td>M: </td><td><a href='tel:$mobileNumber'>$($mobileNumber)</a></td></tr>"})
                  $(if($email){"<tr><td>E: </td><td><a href='mailto:$email'>$($email)</a></td></tr>"})
                  $(if($website){"<tr><td>W:</td><td><a href='https://$website'>$($website)</a></td></tr>"})
              </table>
          </td>
      </tr>
  </table>
</p>
<br />
"@
#>
$signature = 
"
<table
  id='zs-output-sig'
  cellpadding='0'
  cellspacing='0'
  style='
    line-height: 0px;
    font-size: 1px;
    padding: 0px !important;
    border-spacing: 0px;
    margin: 10px;
    border-collapse: collapse;
    width: 600px;
    font-family: Trebuchet MS, Arial, sans-serif;
    box-shadow: rgba(136, 165, 191, 0.48) 6px 2px 16px 0px, rgba(255, 255, 255, 0.8) -6px -2px 16px 0px;
  '>
  <tbody>
    <tr>
      <td style='padding: 0px !important'>
        <table
          id='inner-table2'
          border='0'
          cellpadding='0'
          cellspacing='0'
          background-color:
          #FFFFFF;
          style='line-height: 0px; font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
          <tbody>
            <tr>
              <td style='border-collapse: collapse; font-size: 15px; font-style: normal; line-height: 17px; font-weight: 400; padding-bottom: 14px'>
                <p style='margin: 0.04px'>
                  <span style='font-size: 15px; font-style: normal; line-height: 17px; font-weight: 400; color: #1a1a1a; display: inline'></span>
                </p>
              </td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
    <tr>
      <td style='padding: 0px !important'>
        <table
          id='inner-table'
          border='0'
          cellpadding='0'
          cellspacing='0'
          box-shadow:
          rgba(136,165,191,0.48)
          6px
          2px
          16px
          0px,
          rgba(255,255,255,0.8)
          -6px
          -2px
          16px
          0px;
          style='line-height: 0px; font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
          <tbody>
            <tr>
              <td width='171' style='padding-right: 20px'>
                <table border='0' cellpadding='0' cellspacing='0' style='line-height: 0px; font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
                  <tbody>
                    <tr>
                      <td style='border-collapse: collapse; line-height: 0px; padding-right: 1px'>
                        <p style='margin: 5px'>
                          <img alt='image' border='0' src='https://statics.dc01.cybx.dev/imgs/logo_redondo.png' />
                        </p>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </td>
              <td style='border-collapse: collapse; background-color: #07485c; width: 1px; vertical-align: super; padding: 0px !important'></td>
              <td style='border-collapse: collapse; padding-right: 20px'></td>
              <td style='padding: 0px !important'>
                <table border='0' cellpadding='0' cellspacing='0' style='line-height: 0px; font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
                  <tbody>
                    <tr>
                      <td style='border-collapse: collapse; font-size: 17px; font-style: normal; line-height: 19px; font-weight: 700; padding: 0px !important'>
                        <p style='margin-bottom: 1px'>
                          <span style='font-size: 25px; font-style: normal; font-weight: 700; color: #b07f47; display: inline'>" + $(if($displayName){$displayName} +"
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <p style='margin: 0.04px; margin-left: 10px'>
                          <span style='font-style: oblique; font-size: small; line-height: 17px; color: #1a1a1a; display: inline; font-weight: bold'>Analista de T.I - Setor T.I</span>
                        </p>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>E-mail:</span>
                          <span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'>ti@contabilidadelider.com</span>
                        </p>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <table border='0' cellpadding='0' cellspacing='0' style='font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
                  <tbody>
                    <tr>
                      <td style='border-collapse: collapse; padding: 0px !important'>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>Telefone:</span>
                          <span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'>(44) 3528-5291&nbsp;</span>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'><br />WhatsApp:</span>
                          <span style='font-size: 13; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'>(44) 99733-8394&nbsp;</span>
                        </p>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <table border='0' cellpadding='0' cellspacing='0' style='line-height: 0px; font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
                  <tbody>
                    <tr>
                      <td style='border-collapse: collapse; font-size: 15px; font-style: normal; font-weight: 400; padding: 0px !important'>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>Site:</span>
                          <span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: 13px; color: #1a1a1a; display: inline'>www.contabilidadelider.com</span>
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td style='border-collapse: collapse; font-size: 15px; font-style: normal; font-weight: 400; padding-bottom: 14px'>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>Endereço:</span>
                          <span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'
                            >Av. Don Pedro II, 207, Centro<br />
                            Assis Chateaubriand - PR</span
                          >
                        </p>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <table border='0' cellpadding='0' cellspacing='0' style='line-height: 0px; font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse'>
                  <tbody>
                    <tr>
                      <td style='padding-right: 10px'>
                        <p style='margin: 0.04px'>
                          <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='http://[WHATSAPP]'
                            ><img height='24' width='24' alt='whatsapp' border='0' src='https://img1.gimm.io/assets/social/96/171616/5/whatsapp.png'
                          /></a>
                        </p>
                      </td>
                      <td style='padding-right: 10px'>
                        <p style='margin: 0.04px'>
                          <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='http://[GOOGLEMAPS]'
                            ><img height='24' width='24' alt='map' border='0' src='https://img1.gimm.io/assets/social/96/171616/5/map.png'
                          /></a>
                        </p>
                      </td>
                      <td style='padding-right: 10px'>
                        <p style='margin: 0.04px'>
                          <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='http://[INSTAGRAM]'
                            ><img height='24' width='24' alt='instagram' border='0' src='https://img1.gimm.io/assets/social/96/171616/5/instagram.png'
                          /></a>
                        </p>
                      </td>
                      <td style='padding-right: 10px'>
                        <p style='margin: 0.04px'>
                          <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='http://[YOUTUBE]'
                            ><img height='24' width='24' alt='instagram' border='0' src='https://img1.gimm.io/assets/social/96/171616/5/youtube.png'
                          /></a>
                        </p>
                      </td>
                      <td style='padding-right: 10px'>
                        <p style='margin: 0.04px'>
                          <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='http://[FACEBOOK]'
                            ><img height='24' width='24' alt='facebook' border='0' src='https://img1.gimm.io/assets/social/96/171616/5/facebook.png'
                          /></a>
                        </p>
                      </td>
                      <td style='padding: 0px !important'></td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
    <tr>
      <td style='border-collapse: collapse; padding-bottom: 16px'>
        <span></span>
      </td>
    </tr>
    <tr>
      <td style='border-collapse: collapse'>
        <p style='margin: 5px; font-size: 10px; font-style: normal; line-height: 10px; font-weight: normal; color: #777777'>
          O conteúdo deste e-mail é confidencial e destinado exclusivamente ao destinatário especificado apenas na mensagem. É estritamente proibido compartilhar qualquer parte desta mensagem com
          terceiros, sem o consentimento por escrito do remetente. Se você recebeu esta mensagem por engano, responda a esta mensagem e siga com sua exclusão, para que possamos garantir que tal erro
          não ocorra no futuro.<br />
          <p style='margin: 5px; font-size: 13px; text-align: center; font-style: normal; line-height: 14px; font-weight: normal; color: red'>Antes de imprimir pense no verde, apesar desta mensagem estar em vermelho e sua impressora ser preta e branca</p>
        </p>
      </td>
    </tr>
  </tbody>
</table>"

try {
  $signature | Out-File -FilePath "$file.htm" -Encoding utf8
} catch {
  Write-Host "Error: Unable to save the HTML signature file. Details: $($_.Exception.Message)"
  exit
}

# Output the text to the signatures folder
try {
  $signature | out-file "$file.txt" -encoding utf8
} catch {
  Write-Host "Error: Unable to save the text signature file. Details: $($_.Exception.Message)"
  exit
}

# Setting the regkeys for Outlook 2016
if (test-path "HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\General") 
{
    get-item -path HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\General | new-Itemproperty -name Signatures -value signatures -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\MailSettings | new-Itemproperty -name NewSignature -value $filename -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\MailSettings | new-Itemproperty -name ReplySignature -value $filename -propertytype string -force
    Remove-ItemProperty -Path HKCU:\\Software\\Microsoft\\Office\\16.0\\Outlook\\Setup -Name "First-Run" -ErrorAction silentlycontinue
}

# Setting the regkeys for Outlook 2010 - Thank you AJWhite1970 for the 2010 registry keys
if (test-path "HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\General") 
{
    get-item -path HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\ General | new-Itemproperty -name Signatures -value signatures -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\ MailSettings | new-Itemproperty -name NewSignature -value $filename -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\ MailSettings | new-Itemproperty -name ReplySignature -value $filename -propertytype string -force
    Remove-ItemProperty -Path HKCU:\\Software\\Microsoft\\Office\\14.0\\Outlook\\Setup -Name "First-Run" -ErrorAction silentlycontinue
}
