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

if($user.name.count -gt 0){$displayName = $user.name[0]} # Display Name
if($user.title.count -gt 0){$jobTitle = $user.title[0]} # Job Title
if($user.description.count -gt 0){$setormail = $user.description[0]} # Sector Mail
if($user.initials.count -gt 0){$sector = $user.initials[0]} # Sector Name
$signature = 
"<head>
<meta name='viewport' content='width=device-width, initial-scale=1.0' charset='UTF8'/>
</head>

<body>
<br /><br />
<span style='font-family: Verdana, Geneva, Tahoma, sans-serif;font-size: smaller;'>Atenciosamente,</span>
<table style='		margin-top: 5px;
min-width: 600px;
min-height: 200px;
max-width: 700px;
text-align: justify;
background-color: white;'>
  <tr>
    <td style='width: 180px;'><img style='width: 150px;'alt='logo Escritorio Lider' src='https://statics.dc01.cybx.dev/lider/signature/logo_redondo.png' /></td>
    <td style='width: 1px;
    border-left: 1px solid #91734d;'></td>
    <td style='padding-left: 5px;'>
      <table>
        <tr><td style='    font-family: Verdana, Geneva, Tahoma, sans-serif;    font-weight: bold;
          font-size: medium;
          text-transform: uppercase;
          letter-spacing: 2px;
          color: #91734d'>"+ $(if($displayName){$displayName}) +"</td></tr>
        <tr><td style='    font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-weight: bold;
  font-size: small;
  padding-bottom: 15px;
  color: #5e5e5e'>" + $(if($jobTitle){$jobTitle}) +" - "+ $(if($sector){$sector})+ "</td></tr>
        <tr><td><span style='    font-weight: bold;
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-size:small;
  color: #5e5e5e'>E-mail:</span> <span style='font-family: Verdana, Geneva, Tahoma, sans-serif;'>" + $(if($setormail){$setormail}) +"</span></td></tr>
        <tr><td><span style='    font-weight: bold;
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-size:small;
  color: #5e5e5e'>Telefone:</span> <span style='font-family: Verdana, Geneva, Tahoma, sans-serif;'>(44) 3528-5291</span></td></tr>
        <tr><td><span style='    font-weight: bold;
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-size:small;
  color: #5e5e5e'>WhatsApp:</span> <span style='font-family: Verdana, Geneva, Tahoma, sans-serif;'>(44) 99949-3950</span></td></tr>
        <tr><td><span style='    font-weight: bold;
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-size:small;
  color: #5e5e5e'>Endereço:</span> <span style='font-family: Verdana, Geneva, Tahoma, sans-serif;'>Av. Don Pedro II, 207, Centro <br>Assis Chateaubriand - PR (85935-000)</span></td></tr>
        </table>
        <table>
          <tr>
            <a href='https://wa.me/+5544997338394?text=Menu' rel='noreferrer noopener' target='_blank'>
            <img style='    padding-top: 3px;
  width: 24px;
  padding-right: 3px;' alt='whatsapp' src='https://statics.dc01.cybx.dev/lider/signature/whatsapp.png'/>
          </a>
          </tr>
            <tr>
              <a href='https://goo.gl/maps/QE9hADdec5HVe3Ff7' rel='noreferrer noopener' target='_blank'>
              <img style='    padding-top: 3px;
  width: 24px;
  padding-right: 3px;' alt='map' src='https://statics.dc01.cybx.dev/lider/signature/map.png'/>
            </a>
            </tr>
            <tr>
              <a href='https://www.instagram.com/escritorio.lider/' rel='noreferrer noopener' target='_blank'>
              <img style='    padding-top: 3px;
  width: 24px;
  padding-right: 3px;' alt='instagram' src='https://statics.dc01.cybx.dev/lider/signature/instagram.png'/>
            </a>
            </tr>
            <tr>
              <a href='https://www.youtube.com/@contabilidadelider' rel='noreferrer noopener' target='_blank'>
              <img style='    padding-top: 3px;
  width: 24px;
  padding-right: 3px;' alt='instagram' src='https://statics.dc01.cybx.dev/lider/signature/youtube.png'/>
            </a>
            </tr>
            <tr>
              <a href='https://fb.me/contabilidadelidercom' rel='noreferrer noopener' target='_blank'>
              <img style='    padding-top: 3px;
  width: 24px;
  padding-right: 3px;' alt='instagram' src='https://statics.dc01.cybx.dev/lider/signature/facebook.png'/>
            </a>
            </tr>
        </table>
        <p style='    font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-size: small;'>O conte&uacute;do deste e-mail &eacute; confidencial e destinado exclusivamente ao destinat&aacute;rio especificado apenas na mensagem. &Eacute; estritamente proibido compartilhar qualquer parte desta mensagem com
      terceiros, sem o consentimento por escrito do remetente. Se voc&ecirc; recebeu esta mensagem por engano, responda a esta mensagem e siga com sua exclus&atilde;o, para que possamos garantir que tal erro
      n&atilde;o ocorra no futuro.</p>
      <p style='    font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-size: small;color: red;'>Antes de imprimir pense no verde, apesar desta mensagem estar em vermelho e sua impressora ser preta e branca</p>
    </td>
    </td>
  </tr>
</table>
</body>

"
try {
  $signature | Out-File -FilePath "$file.htm" -Encoding UTF8
} catch {
  Write-Host "Error: Unable to save the HTML signature file. Details: $($_.Exception.Message)"
  exit
}

# Output the text to the signatures folder
try {
  $signature | out-file "$file.txt"  -Encoding UTF8
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