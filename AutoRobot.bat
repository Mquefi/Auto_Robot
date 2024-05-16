@echo off
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
   echo.
) ELSE (
   echo.-------------------------------------------------------------
   echo ERROR: YOU ARE NOT RUNNING THIS WITH ADMINISTRATOR PRIVILEGES.
   echo ERRO: VOCE NAO ESTA EXECUTANDO COM PRIVILEGIOS DE ADMINISTRATOR.
   echo. -------------------------------------------------------------
   echo. If you're seeing this, it means you don't have admin privileges!
   echo. Se voce esta vendo isto, significa que voce nao tem privilegios de administrador!
   pause
   echo.
   echo. You will need to restart this program with Administrator privileges by right-clicking and select "Run As Administrator"
   echo. Voce precisa reiniciar este programa com privilegios de administrador clicando com o botao direito e selecionando "Executar como Administrador"
   pause
   echo.
   echo Press any key to leave this program. Make sure to Run As Administrator next time!
   echo Aperte qualquer tecla pra sair deste programa. Tenha certeza de executar como Administrador na proxima vez!
   pause
   EXIT /B 1
)

:: Este código irá fazer a instalação do Chocolatey no equipamento.
:: This script installs Chocolatey and some programs

@echo off
cls

set $choco_install=Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
set $program_install=choco install
set $upgrade_install=choco upgrade all
set $navegacao=0
::set $programs=googlechrome git vscode sublimetext3 discord k-litecodecpackfull

::Cria um txt com o número da versão
REM echo versão 1.0 > C:/Tools/versao.txt

::Estas duas linhas definem as variáveis "file" e "result". A variável "file" armazena o caminho completo para o arquivo de texto que desejamos verificar. A variável "result" armazena o resultado da verificação, inicialmente definido como "nok".
REM set "file=c:\Install\versao.txt"
REM set "result=nok"

::Esta linha é o início de um loop "for". O loop será executado uma vez para cada linha
::no arquivo especificado pela variável "file". A opção "delims=" significa que o
::delimitador padrão (espaço ou tab) não será usado para separar as linhas do arquivo,
::de modo que cada linha inteira será tratada como uma única string. A variável "i"
::será usada para armazenar o conteúdo de cada linha do arquivo durante a execução 
::do loop.
REM for /f "delims=" %%i in (%file%) do (

::Dentro do loop, esta é uma verificação condicional que verifica se o conteúdo da
::linha atual (armazenado na variável "i") é igual a "versão 1.0". Se a verificação
::for verdadeira, a variável "result" é definida como "ok".

REM  if "%%i" == "versão 1.0" (
REM    set "result=ok"
REM  )
REM)

echo %result%


:menu

:: Desenvolvido por: Marcello Queiroz
:: Data: 01/02/2023 - V.0.5
:: Sistema de automação para Instalação / Atualização de Softwares

color 70
date /t
@echo.
echo     ___         __           ____        __          __ 
echo    /   \ __  __/ /_____     / __ \____  / /_  ____  / /_
echo   / /_\ / / / / __/ __ \   / /_/ / __ \/ __ \/ __ \/ __/
echo  / ___ / /_/ / /_/ /_/ /  / _  _/ /_/ / /_/ / /_/ / /_  
echo /_/  /_\__ _/\__/\____/  /_/ /_/\____/\____/\____/\__/
echo.

echo    _______________________________________________________________________
echo    =======================================================================
echo    ==                   [1] Criar instalador automatico de programas    ==
echo    ==                   [2] Instalar programas padroes                  ==
echo    ==                   [3] Instalar ERP-S                              ==
echo    ==    -------    /   [4] Verificar programas instalados              ==
echo    ==   / () () \\ /\   [5] Buscar e atualizar programas no equipamento ==
echo    ==  /        /////   [6] Executar todas as operacoes                 ==
echo    ==   \\______///     [7] Instalar programas TI (DEV)                 ==
echo    ==   _(____)/ /      [8] Sair                                        ==
echo    ==__/ __ _  _/_______________________________________________________==
echo    =====\\___\\_) ========================================================
echo         /______/
echo         /  //  /
echo         /__//__/
echo         (__)(__)
echo.

set /p opcao=Digite a opcao desejada:

if "%opcao%" == "1" goto op1
if "%opcao%" == "2" goto op2
if "%opcao%" == "3" goto op3
if "%opcao%" == "4" goto op4
if "%opcao%" == "5" goto op5
if "%opcao%" == "6" goto op6
if "%opcao%" == "7" goto op7
if "%opcao%" == "8" goto op8

::-----------------------------------------------------
:op1
cls
echo Executando opcao [1]
echo.
:install

:: Checks if choco is a recognized command
WHERE choco >nul
if %ERRORLEVEL% neq 0 echo choco not installed yet & goto :install_choco
echo [92mchoco already installed[0m & goto menu

:: Installs choco
:install_choco
echo.
echo [92mInstalling Chocolatey...[0m
for /f "delims=" %%a in ('powershell -command Get-ExecutionPolicy') do set "$policy_value=%%a"
echo Get-ExecutionPolicy : %$policy_value%
if %$policy_value%==Restricted start powershell -Command "&{ Start-Process powershell -ArgumentList '-command Set-ExecutionPolicy AllSigned' -Verb RunAs}"

:: Resolves a problem of '' inside ''
set $choco_install=%$choco_install:'=''%
powershell -Command "&{ Start-Process powershell -ArgumentList '-command %$choco_install%' -Verb RunAs}"
echo.
echo ============Instalacoes Finalizadas com Sucesso============

echo DESATIVANDO O UAC
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
echo.
echo O computador irá reiniciar em 90 segundos, favor aguardar...
echo.
timeout /t 90
shutdown /r
exit

::-----------------------------------------------------
:op2
cls
echo Executando opcao [2]

:: Installs or Upgrades programs from choco
:install_programs

echo.
:choice_progrs
choice /c YN /n /t 10000 /d N /m "Você deseja instalar outros programas [Y/N]? "
if errorlevel 2 goto :keep_programs
if errorlevel 1 goto :add_programs

:: Allows the user to install a custom list of programs
:add_programs
echo.
echo [92mCustom package list[0m
echo Informe a lista de programas que você quer instalar.
echo [91mATENÇÃO[0m você tem que informar manualmente os programas que deseja instalar
echo [92mEncontre os códigos aqui[0m https://community.chocolatey.org/packages
echo.
set /p $programs=Insira a lista de programas (separadas por espaço):
goto :install_programs_install

:: Constinues the instalation with the default programs
:keep_programs
echo.
echo Nenhum outro programa será instalado
goto :install_programs_install

:: Installs the programs selected
:install_programs_install
echo.
echo [92mInstalando Programas...[0m
choco install jre8 -y
choco install adobereader -y
choco install googlechrome -y
choco install microsoft-edge -y
choco install 7zip -y
choco install anydesk.install -y
choco install foxitreader -y
choco install openvpn-connect -y
::choco install office365business -y
::choco install tightvnc

REM cd %~dp0
REM cd Programas
REM echo Kaspersky (Anti Virus)
REM start /wait installer.exe /S

echo.
echo ============Instalacoes Finalizadas com Sucesso============
pause
goto menu

::-----------------------------------------------------
:op3
cls
echo Executando opcao [3]
echo Para o correto funcionamento, o equipamento deve estar na rede interna
echo.
mklink "C:\Users\Public\Desktop\Sisma" "\\192.168.0.243\Sisma$\sisma.exe"
echo Instalacao do Sisma Finalizado
echo.

xcopy /y "\\192.168.0.50\InstallGpo$\smartclient" "C:\totvs\smartclient" /e /h /r /i
echo Instalacao do Protheus Finalizado
echo.

mklink "C:\Users\Public\Desktop\Protheus" "C:\totvs\smartclient\smartclient.exe"
echo Atalho do Protheus incluido na area de trabalho
echo.

echo Criando pasta Tools dentro de C:
echo.
cd c:\
mkdir Tools

echo Copiando aplicativos adicionais para pasta Tools
xcopy /y "\\192.168.0.50\InstallGpo$\SistemasPadroes" "C:\Tools" /e /h /r /i
echo Copia finalizada, favor acessar a pasta C:Tools e realizar a instalacao dos aplicativos manualmente
echo.

::echo Instalando RM
::C:\Tools\RM\BIBLIOTECARM-12.1.32.MSI /passive /qr configtotvsupdate=true servertotvsupdate=192.168.0.243 portatotvsupdate=8050 layer=client hostserver=192.168.0.243 hostport=8050 lang=pt-BR
::echo.
::timeout /t 90

copy /y "\\192.168.0.50\InstallGpo$\RM.exe.config" "C:\totvs\CorporeRM\RM.Net\RM.exe.config"
echo Plugin RM de atualizacao automatica copiado
echo.
echo ============Instalacoes Finalizadas com Sucesso============
pause
goto menu

::-----------------------------------------------------
:op4
cls
echo Executando opcao [4]
choco list -localonly
pause
goto menu

::-----------------------------------------------------
:op5
cls
echo Executando opcao [5]
choco outdated

:: Upgrades all programs
:upgrade_programs
echo.
echo [92mUpgrading All Packages...[0m
powershell -Command "&{ Start-Process powershell -ArgumentList '-command %$upgrade_install% -y' -Verb RunAs}"
pause
goto menu

::-----------------------------------------------------
:op6
cls
echo Executando opcao [6]
echo Instalando e atualizando todo o sistema.
echo.

:: ##### PARTE 02
:: Installs or Upgrades programs from choco
:install_programs2

echo.

:: Installs the programs selected
echo.
echo [92mInstalando Programas...[0m
choco install jre8 -y
choco install adobereader -y
choco install googlechrome -y
choco install microsoft-edge -y
choco install 7zip -y
choco install anydesk.install -y
choco install foxitreader -y
choco install openvpn-connect -y
::choco install office365business -y
::choco install tightvnc

REM cd %~dp0
REM cd Programas
REM echo Kaspersky (Anti Virus)
REM start /wait installer.exe /S

echo.
echo ============Instalacoes Finalizadas com Sucesso============

:: ##### PARTE 03
echo.
mklink "C:\Users\Public\Desktop\Sisma" "\\192.168.0.243\Sisma$\sisma.exe"
echo Instalacao do Sisma Finalizado
echo.

xcopy /y "\\192.168.0.243\c$\TOTVS\Microsiga\Protheus12\Aplicativos\smartclient" "C:\totvs\smartclient" /e /h /r /i
echo Instalacao do Protheus Finalizado
echo.

mklink "C:\Users\Public\Desktop\Protheus" "C:\totvs\smartclient\smartclient.exe"
echo Atalho do Protheus incluido na area de trabalho
echo.

echo Criando pasta Tools dentro de C:
echo.
cd c:\
mkdir Tools

echo Copiando aplicativos adicionais para pasta Tools
xcopy /y "\\192.168.0.50\InstallGpo$\SistemasPadroes" "C:\Tools" /e /h /r /i
echo Copia finalizada, favor acessar a pasta C:Tools e realizar a instalacao dos aplicativos manualmente
echo.

::echo Instalando RM
::C:\Tools\RM\BIBLIOTECARM-12.1.32.MSI /passive /qr configtotvsupdate=true servertotvsupdate=192.168.0.243 portatotvsupdate=8050 layer=client hostserver=192.168.0.243 hostport=8050 lang=pt-BR
::echo.
::timeout /t 90

copy /y "\\192.168.0.50\InstallGpo$\RM.exe.config" "C:\totvs\CorporeRM\RM.Net\RM.exe.config"
echo Plugin RM de atualizacao automatica copiado
echo.

:: ##### PARTE 04
choco list -localonly

:: ##### PARTE 05
choco outdated

:: Upgrades all programs
echo.
echo [92mUpgrading All Packages...[0m
powershell -Command "&{ Start-Process powershell -ArgumentList '-command %$upgrade_install% -y' -Verb RunAs}"

:: ##### PARTE 06

:: ##### PARTE 07
echo INSTALAÇÕES FINALIZADAS COM SUCESSO
pause
cls
goto menu

::-----------------------------------------------------
:op7
cls

choco install vscode -y
choco install git -y
choco install sql-workbench -y
choco install notepadplusplus -y
choco install virtualbox -y
choco install eclipse-jee-luna -y
echo.
echo       )  (
echo      (   ) )
echo       ) ( (
echo     _______)_
echo   ------------  
echo ( C /\/\/\/\/-
echo   - /\/\/\/\/-
echo    -_________-
echo      -------

echo Instalação Concluida

pause
goto menu

::-----------------------------------------------------
:op8
cls
echo Executando opcao [8]

:: Stops execution of the script
:exit
echo.
echo [91mExiting...[0m
exit