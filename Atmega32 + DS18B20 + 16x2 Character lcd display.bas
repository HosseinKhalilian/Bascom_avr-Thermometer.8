'======================================================================='

' Title: LCD Display Thermometer * Multiple Sensors
' Last Updated :  05.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : Atmega32 + DS18B20 + 16x2 Character lcd display

'======================================================================='

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Portc.0 , E = Portc.2 , Db4 = Portc.4 , Db5 = Portc.5 , Db6 = Portc.6 , Db7 = Portc.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config 1wire = Porta.0

Dim Temperature As String * 6
Dim Buffer_digital As Integer
Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Ds18b20_id_3(8) As Byte
Dim Ds18b20_id_4(8) As Byte


Deflcdchar 0 , 232 , 244 , 232 , 227 , 228 , 228 , 227 , 224

Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Ds18b20_id_3(1) = 1wsearchnext()
Ds18b20_id_4(1) = 1wsearchnext()

Cls
Locate 1 , 1 : Lcd "   Thermometer"
Locate 2 , 1 : Lcd " ------------------"
Wait 2
Cls
Waitms 500



'------------------------------------------------------

Do
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 750

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Locate 1 , 1 : Lcd "1:" ; Temperature ; Chr(0)


   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_2(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Locate 1 , 9 : Lcd "2:" ; Temperature ; Chr(0)


   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_3(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Locate 2 , 1 : Lcd "3:" ; Temperature ; Chr(0)

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_4(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Locate 2 , 9 : Lcd "4:" ; Temperature ; Chr(0)
Loop

End

'--------------------------------------------

Conversion:
   Buffer_digital = Buffer_digital * 10 : Buffer_digital = Buffer_digital \ 16
   Temperature = Str(buffer_digital) : Temperature = Format(temperature , "0.0")
Return

'--------------------------------------------

