#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>

#include <EXTERN.h>
#include <perl.h>
static PerlInterpreter *my_perl;

using namespace std;

static const string FILENAME = "base64_text.txt";
static const string base64_chars = 
                         "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                         "abcdefghijklmnopqrstuvwxyz"
                         "0123456789+/";


static inline bool is_base64(unsigned char c) {
    return (isalnum(c) || (c == '+') || (c == '/'));
}

string base64_decode(string & encoded_string)
{
    int in_len = encoded_string.size();
    int i = 0;
    int j = 0;
    int in_ = 0;
    unsigned char char_array_4[4], char_array_3[3];
    string ret;

    while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
        char_array_4[i++] = encoded_string[in_]; in_++;
        if (i ==4) {
            for (i = 0; i <4; i++)
                char_array_4[i] = base64_chars.find(char_array_4[i]);

            char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
            char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
            char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

            for (i = 0; (i < 3); i++)
                ret += char_array_3[i];
            i = 0;
        }
    }

    if (i) {
        for (j = i; j <4; j++)
            char_array_4[j] = 0;

        for (j = 0; j <4; j++)
            char_array_4[j] = base64_chars.find(char_array_4[j]);

        char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
        char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
        char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

        for (j = 0; (j < i - 1); j++) ret += char_array_3[j];
    }

    return ret;
}

vector <pair <string, int> > statistics(string text)
{
    map <string, int> words;
    vector <pair <string, int> > result;
    vector <pair <int, string> > tmp;

    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv_2mortal(newSVpv(text.c_str(), 0)));
    PUTBACK;
    int count = call_pv("statistics", G_ARRAY);
    SPAGAIN;
    int pairs = POPi;
    for (int i = 0; i < pairs; i++)
    {
        pair <int, string> p;
        p.second = POPp;
        p.first = POPi;
        tmp.push_back(p);
    }
    FREETMPS;
    LEAVE;
    sort(tmp.begin(), tmp.end());
    result.resize((int)tmp.size());
    for (int i = 0; i < (int)tmp.size(); i++)
        result[i] = make_pair(tmp[i].second, tmp[i].first);
    
    return result;
}

int main(int argc, char **argv, char **env)
{
    PERL_SYS_INIT3(&argc,&argv,&env);
    my_perl = perl_alloc();
    perl_construct(my_perl);
    
    perl_parse(my_perl, NULL, argc, argv, NULL);
    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;

    ios_base::sync_with_stdio(0);
    cin.tie(NULL);

    ifstream cin(FILENAME);
    string text;
    cin >> text;
    vector <pair <string, int> > stats = statistics(base64_decode(text));
    for (int i = 0; i < (int)stats.size(); i++)
        cout << stats[i].first << " = " << stats[i].second << endl;
    cin.close();



    perl_destruct(my_perl);
        perl_free(my_perl);
    PERL_SYS_TERM();

    return 0;
}