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
"<br><br>
<span>Atenciosamente,</span><br>
<div style='background-color: #CCCCCC; bottom: 4px;position: relative;right: 4px;'>

<table
  id='zs-output-sig'
  cellpadding='0'
  cellspacing='0'
  style='
  background-color: #FFFFFF;
  border: 1px solid #000000;
  color: #000000;
  padding: 0.5em;
  bottom: 4px;position: relative;right: 4px;
    line-height: 0px;
    font-size: 1px;
    padding: 0px !important;
    border-spacing: 0px;
    background-color: white;
    margin: 10px;
    border-collapse: collapse;
    width: 600px;
    font-family: Trebuchet MS, Arial, sans-serif;
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
                          <img alt='image' border='0' src='https://statics.dc01.cybx.dev/lider/signature/logo_redondo.png' />
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
                          <span style='font-size: 25px; font-style: normal; font-weight: 700; color: #b07f47; display: inline'>" + $(if($displayName){$displayName}) +"
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <p style='margin: 0.04px; margin-left: 5px'>
                          <span style='font-style: oblique; font-size: small; line-height: 17px; color: #1a1a1a; display: inline; font-weight: bold'>" + $(if($jobTitle){$jobTitle}) +" - "+ $(if($sector){$sector})+ "</span>
                        </p>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>E-mail: </span>
                          <a style='text-decoration:none !important; text-decoration:none;' href='mailto:" + $(if($setormail){$setormail}) +"' target='_blank' rel='nofollow'><span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: 13px; color: #1a1a1a; display: inline'>" + $(if($setormail){$setormail}) +"</span><a></>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <table border='0' cellpadding='0' cellspacing='0' style='font-size: 1px; padding: 0px !important; border-spacing: 0px; margin: 0px; border-collapse: collapse; background-color: white'>
                  <tbody>
                    <tr>
                      <td style='border-collapse: collapse; padding: 0px !important'>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>Telefone: </span>
                          <a href='tel:044-3528-5291' style='text-decoration:none !important; text-decoration:none;' class='external'><span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'>(44) 3528-5291</span></a>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'><br />WhatsApp: </span>
                          <a href='https://wa.me/+5544997338394?text=Menu' style='text-decoration:none !important; text-decoration:none;' ><span style='font-size: 13; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'>(44) 99733-8394</span></a>
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
                          <a style='text-decoration:none !important; text-decoration:none;'  href='" + $(if($setormail){$setormail}) +"' target='_blank' rel='nofollow'><span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: 13px; color: #1a1a1a; display: inline'>www.contabilidadelider.com</span></a>
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td style='border-collapse: collapse; font-size: 15px; font-style: normal; font-weight: 400; padding-bottom: 14px'>
                        <p style='margin: 0.04px'>
                          <span style='font-size: 14px; font-style: normal; line-height: 17px; font-weight: bold; color: #074c61; display: inline'>Endereço:</span>
                          <a href='https://goo.gl/maps/QE9hADdec5HVe3Ff7' style='text-decoration:none !important; text-decoration:none;' > <span style='font-size: 13px; font-style: normal; line-height: 17px; font-weight: normal; color: #1a1a1a; display: inline'
                            >Av. Don Pedro II, 207, Centro<br />
                            Assis Chateaubriand - PR</span
                          ></a>

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
                      <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='https://wa.me/+5544997338394?text=Menu'
                        ><img height='24' width='24' alt='whatsapp' border='0' src='https://statics.dc01.cybx.dev/lider/signature/whatsapp.png'
                      /></a>
                    </p>
                  </td>
                  <td style='padding-right: 10px'>
                    <p style='margin: 0.04px'>
                      <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='https://goo.gl/maps/QE9hADdec5HVe3Ff7'
                        ><img height='24' width='24' alt='map' border='0' src='https://statics.dc01.cybx.dev/lider/signature/map.png'
                      /></a>
                    </p>
                  </td>
                  <td style='padding-right: 10px'>
                    <p style='margin: 0.04px'>
                      <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='https://www.instagram.com/escritorio.lider/'
                        ><img height='24' width='24' alt='instagram' border='0' src='https://statics.dc01.cybx.dev/lider/signature/instagram.png'
                      /></a>
                    </p>
                  </td>
                  <td style='padding-right: 10px'>
                    <p style='margin: 0.04px'>
                      <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='https://www.youtube.com/@contabilidadelider'
                        ><img height='24' width='24' alt='instagram' border='0' src='https://statics.dc01.cybx.dev/lider/signature/youtube.png'
                      /></a>
                    </p>
                  </td>
                  <td style='padding-right: 10px'>
                    <p style='margin: 0.04px'>
                      <a style='font-size: 0px; line-height: 0px' target='_blank' rel='nofollow' href='https://fb.me/contabilidadelidercom'
                        ><img height='24' width='24' alt='facebook' border='0' src='https://statics.dc01.cybx.dev/lider/signature/facebook.png'
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
</table>
</div>"
$replacements = @{
  "á" = "&#xE1;"
  "é" = "&#xE9;"
  "í" = "&#xED;"
  "ó" = "&#xF3;"
  "ú" = "&#xFA;"
  "ã" = "&#xE3;"
  "õ" = "&#xF5;"
  "ç" = "&#xE7;"
}
#replace utf8 problems in powershell accents.
$signature = $signature.Replace("á", $replacements["á"])
$signature = $signature.Replace("é", $replacements["é"])
$signature = $signature.Replace("í", $replacements["í"])
$signature = $signature.Replace("ó", $replacements["ó"])
$signature = $signature.Replace("ú", $replacements["ú"])
$signature = $signature.Replace("ã", $replacements["ã"])
$signature = $signature.Replace("õ", $replacements["õ"])
$signature = $signature.Replace("ç", $replacements["ç"])
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