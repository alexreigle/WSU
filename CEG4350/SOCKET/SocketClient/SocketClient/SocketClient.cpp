#pragma once
#include <Windows.h>
#include <iostream>
#include <winsock.h>
#include <fstream>
#include <vector>
#include <string>
#include <time.h>

using namespace std;

vector<int> Producer();

void newfile(string);
vector<int> generate(int, int);
void write(string, vector<int>);

int main()
{
    cout << "\t\t------UDP Client------" << endl << endl;

    //Produce the Data
    vector<int> data = Producer();
    char dataChar[512] = "";
    for (int i = 0; i < data.size(); i++)
    {
        dataChar[i] = ('0' + data[i]);		//Convert data into character values to be printed and transfered across pipe
    }

    //Local Variables
    WSADATA     WinSockData;
    int         iWsaStartup;
    int         iWsaCleanup;

    SOCKET      UDPSocketClient;
    struct      sockaddr_in     UDPServer;

    //char        Buffer[512]     = "Hello from Client!";
    int         iSendto;

    //int         iBufferLen      = strlen(Buffer) + 1;
    int         iBufferLen = strlen(dataChar) + 1;
    int         iUDPServerLen   = sizeof(UDPServer);
    int         iCloseSocket;

    //WSAStartUp
    iWsaStartup = WSAStartup(MAKEWORD(2, 2), &WinSockData);
    if (iWsaStartup != 0) { cout << "WSAStartUp function Failed." << endl; }
    //else { cout << "WSAStartup function Success." << endl; }

    //Fill UDPServer(socket address) Struct
    UDPServer.sin_family = AF_INET;
    UDPServer.sin_addr.s_addr = inet_addr("127.0.01");
    UDPServer.sin_port = htons(1025);     //Convert Port Number from Litle Endian to Big Endian


    //Socket Creation
    UDPSocketClient = socket(
        AF_INET,
        SOCK_DGRAM,
        IPPROTO_UDP
    );
    if (UDPSocketClient == INVALID_SOCKET) { cout << "Socket Creation Failed with Error # " << WSAGetLastError() << endl; }
   // else { cout << "Socket Creation Success." << endl; }

    //Send Data to Server
    iSendto = sendto(
        UDPSocketClient,
        dataChar, //Buffer,
        iBufferLen,
        MSG_DONTROUTE,
        (SOCKADDR*)&UDPServer,
        sizeof(UDPServer)
    );
    if(iSendto == SOCKET_ERROR) { cout << "Sending Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "Sending Success." << endl; }

    //closesocket
    iCloseSocket = closesocket(UDPSocketClient);
    if (iCloseSocket == SOCKET_ERROR) { cout << "Close Socket Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "Close Socket Success." << endl; }

    //WSAStartUp
    iWsaCleanup = WSACleanup();        //Uses Winsock 2 DLL (Ws2_32.dll)
    if (iWsaCleanup == SOCKET_ERROR) { cout << "WSA CleanUp Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "WSA CleanUp Success." << endl; }

    return 0;
}

vector<int> Producer()
{
    cout << "Producer Process Entered.\n";

    int size = 100;		// Number of randomly generated integers
    int upLim = 100;	// Upper limit to range of randomly generated integers. 
    string writeLocation = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\SOCKET";
    string file = writeLocation + "\\ProducerFile.txt"; //File produced, saving the data
    vector<int> data(size);

    newfile(file); //Create a new file to save data 
    data = generate(upLim, size); //Generate size number of random integers between 0 and uplim
    write(file, data); //Print data and Write it to a file

    return data;
}

void newfile(string path1)
{
    ofstream a;
    a.open(path1);
    a.close();
}
vector<int> generate(int lim, int sz)
{
    vector<int> data(sz);

    srand(time(NULL));
    for (int idx = 0; idx < sz; idx++)
    {
        data[idx] = rand() % lim + 1;
    }

    return data;
}
void write(string path, vector<int> data)
{
    fstream file;
    file.open(path);

    int idx = 0;
    int sz = data.size();

    cout << "Data Written to Socket" << endl;
    while (idx < sz)
    {
        file << data[idx] << endl;
        cout << data[idx] << " ";
        idx++;
    } cout << endl;
    file.close();

}
