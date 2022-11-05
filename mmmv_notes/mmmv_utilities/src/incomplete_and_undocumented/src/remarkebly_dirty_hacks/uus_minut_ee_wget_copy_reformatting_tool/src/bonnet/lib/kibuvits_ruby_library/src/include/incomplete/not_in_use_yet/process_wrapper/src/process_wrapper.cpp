// Author: Martin Vahi, martin.vahi@softf1.com
// This file is licensed under the BSD license.
// http://www.opensource.org/licenses/bsd-license.php
//---------------------------------------------------------------------
#include <unistd.h>
#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <cstdlib>
//#include <obstack.h>
#include <stdarg.h>
#include <stdio.h>
//#include <algorithm>
//#include <utility>
//#include <vector>
//#include <exception>
//#include <stdexcept>
//---------------------------------------------------------------------
namespace kibuvits_process_wrapper {
using namespace std;
#ifdef KIBUVITS_PROCESS_WRAPPER_ON_LINUX
//---------------------------------------------------------------------

int system(string s_shellscript) {
        int i=0;
        const char* script=s_shellscript.c_str();
        // There will be an infinite recursion, if
        // the "std::" is erased.
        i=std::system(script);
        return i;
        };

//---------------------------------------------------------------------
#else //KIBUVITS_PROCESS_WRAPPER_ON_WINDOWS
//---------------------------------------------------------------------
int system(string s_shellscript) {
        string msg=""
                   msg+="\n\n Function has not been implemented yet.\n"
                        "(" + __FILE__ + ",\nline No." + __LINE__ + ")\n\n"
                        cout << msg
                        throw()
                        };
//---------------------------------------------------------------------
#endif //KIBUVITS_PROCESS_WRAPPER_ON_LINUX

        } //namespace kibuvits_process_wrapper
//---------------------------------------------------------------------

int main(int argc, char *argv[]) {
        cout<<"\n Greetings from main.cpp! \n";
        int i_out=0;
        return i_out;
        }// main()
;

