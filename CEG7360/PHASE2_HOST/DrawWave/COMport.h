// This header file defines a COM Port class.
// It is based on the code in http://members.ee.net/brey/Serial.pdf

class COMport
{
private:
	CString which_port;
	HANDLE hPort;

	int Initialize_COM_Port(CString, HANDLE&);
	int ReadByte(HANDLE, char*, int);
	int WriteComPort(HANDLE, CString, int);

public:
	COMport(CString port = _T("COM6")) { which_port = port; (void)Initialize_COM_Port(which_port, hPort); } // constructor
	~COMport(void) { CloseHandle(hPort); } // destructor

	void read_n_data(char*, int, int = 1);
	void write_n_data(char*, int);
	void write_and_read(char&);
};
