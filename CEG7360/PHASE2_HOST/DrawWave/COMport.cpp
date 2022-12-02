// This CPP file implements the member functions of the COM Port class.
// It is based on the code in http://members.ee.net/brey/Serial.pdf

#include <atlstr.h>
#include "COMport.h"  

void COMport::read_n_data(char* data, int no_bytes, int append_end_of_string)
{
	(void)ReadByte(hPort, data, no_bytes);
	if (append_end_of_string) data[no_bytes] = 0; // default: append end of string
}

void COMport::write_n_data(char* data, int no_bytes)
{
	for (int i = 0; i < no_bytes; i++)
	{
		// (void) WriteComPort(hPort, (CString) b, strlen(b)); // write a string
		(void)WriteComPort(hPort, (CString)data[i], 1); // write a single character			
	}
	//(void) WriteComPort(hPort, (CString) data, no_bytes);
}

void COMport::write_and_read(char& ch)
{
	(void)WriteComPort(hPort, (CString)ch, 1); // write a single character
	(void)ReadByte(hPort, &ch, 1);
}

int COMport::Initialize_COM_Port(CString PortSpecifier, HANDLE& hPort)
{
	DCB dcb;

	hPort = CreateFile(
		PortSpecifier,
		GENERIC_READ | GENERIC_WRITE,
		0,
		NULL,
		OPEN_EXISTING,
		0,
		NULL
	);

	if (!GetCommState(hPort, &dcb)) return 0x100;

	dcb.BaudRate = CBR_9600; //9600 Baud
	dcb.ByteSize = 8; //8 data bits
	dcb.Parity = NOPARITY; //no parity
	dcb.StopBits = ONESTOPBIT; //1 stop

	if (!SetCommState(hPort, &dcb)) return 0x100;
	return 0;
}

int COMport::ReadByte(HANDLE hPort, char* data, int no_bytes)
{
	int retVal;
	DWORD dwBytesTransferred;
	DWORD dwCommModemStatus;

	SetCommMask(hPort, EV_RXCHAR | EV_ERR); //receive character event
	WaitCommEvent(hPort, &dwCommModemStatus, 0); //wait for the first character

	Sleep(100); // delay 0.1 second until all characters have arrived

	if (dwCommModemStatus & EV_RXCHAR)
	{
		ReadFile(hPort, data, no_bytes, &dwBytesTransferred, 0); //read 1
		retVal = (int)data[0];
	}
	else if (dwCommModemStatus & EV_ERR)
		retVal = 0x101;

	return retVal;
}

int COMport::WriteComPort(HANDLE hPort, CString data, int no_of_bytes)
{
	DWORD byteswritten;
	return WriteFile(hPort, data, no_of_bytes, &byteswritten, NULL);
}
