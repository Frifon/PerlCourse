#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "math.h"

double _distance_p2p(double x1, double y1, double x2, double y2)
{
    return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}

double _distance_p2c(double px, double py, double cx, double cy, double r)
{
    return fabs(r - _distance_p2p(px, py, cx, cy));
}

int ** _MMC(int ** A, int n, int m)
{
    printf("%d %d", n, m);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            printf("%d ", A[i][j]);
        }
        printf("\n");
    }
    return A;
}

MODULE = Math::Geom		PACKAGE = Math::Geom		

SV*
MMC(r_A, r_B)
    SV *r_A
    SV *r_B
    CODE:
        if(!(SvOK(r_A) && SvROK(r_A))) croak("First matrix isn't an arrayref!");
        if(!(SvOK(r_B) && SvROK(r_B))) croak("Second matrix isn't an arrayref!");

        SV *_A = SvRV(r_A);
        SV *_B = SvRV(r_B);

        if (SvTYPE(_A) != SVt_PVAV) croak("First matrix isn't an arrayref!");
        if (SvTYPE(_B) != SVt_PVAV) croak("Second matrix isn't an arrayref!");

        AV *A = (AV*)_A;
        AV *B = (AV*)_B;

        int rows_a = av_len(A) + 1;
        int rows_b = av_len(B) + 1;
        int cols_a = -1, cols_b = -1;

        if (!rows_a || !rows_b) croak("Matrix can't be empty");

        for (int i = 0; i < av_len(A) + 1; i++)
        {
            SV **r_row = av_fetch(A, i, 0);
            if(!(SvOK(*r_row) && SvROK(*r_row))) croak("First matrix hasn't arrayhefs inside!");
            SV *_row = SvRV(*r_row);
            if (SvTYPE(_row) != SVt_PVAV) croak("First matrix hasn't arrayhefs inside!");
            AV *row = (AV*)_row;
            if (!i) cols_a = av_len(row);
            else if (cols_a != av_len(row)) croak("Lengths of lines in first matrix aren't equal!");
        }

        for (int i = 0; i < av_len(B) + 1; i++)
        {
            SV **r_row = av_fetch(B, i, 0);
            if(!(SvOK(*r_row) && SvROK(*r_row))) croak("First matrix hasn't arrayhefs inside!");
            SV *_row = SvRV(*r_row);
            if (SvTYPE(_row) != SVt_PVAV) croak("First matrix hasn't arrayhefs inside!");
            AV *row = (AV*)_row;
            if (!i) cols_b = av_len(row);
            else if (cols_b != av_len(row)) croak("Lengths of lines in first matrix aren't equal!");
        }

        cols_a++; cols_b++;

        if (cols_a != rows_b) croak("N x K ... K x M");

        AV* result = (AV *)sv_2mortal((SV *)newAV());

        for (int i = 0; i < rows_a; i++)
        {
            AV* tmp = (AV *)sv_2mortal((SV *)newAV());
            for (int j = 0; j < cols_b; j++)
            {
                int cur = 0;
                for (int t = 0; t < cols_a; t++)
                {
                    SV *el_A = (SV*)SvRV(*av_fetch((AV*)SvRV(*av_fetch(A, i, 0)), t, 0));
                    SV *el_B = (SV*)SvRV(*av_fetch((AV*)SvRV(*av_fetch(B, t, 0)), j, 0));
                    cur += (int)el_A * (int)el_B;
                }
                av_push(tmp, newSViv(cur));
            }
            av_push(result, newRV((SV *)tmp));
        }

        RETVAL = newRV((SV *)result);
    OUTPUT:
        RETVAL

        

        
        


double
distance_p2c(r_point, r_circle)
    SV *r_point
    SV *r_circle
    PPCODE:
        double px, py, cx, cy, r;
        if(!(SvOK(r_point) && SvROK(r_point) && SvOK(r_circle) && SvROK(r_circle)))
        {
            croak("Point and Circle have to be hashrefs!");
        }
        SV *_point = SvRV(r_point);
        SV *_circle = SvRV(r_circle);
        if (SvTYPE(_point) != SVt_PVHV || SvTYPE(_circle) != SVt_PVHV)
        {
            croak("Point and Circle have to be hashrefs!");
        }
        HV *point = (HV*)_point;
        HV *circle = (HV*)_circle;
        if (!(hv_exists(point, "x", 1) && hv_exists(point, "y", 1)))
        {
            croak("Point hasn't x or y field!");
        }
        if (!(hv_exists(circle, "x", 1) && hv_exists(circle, "y", 1) && hv_exists(circle, "r", 1)))
        {
            croak("Circle hasn't x or y or r field!");
        }
        SV **_px, **_py, **_cx, **_cy, **_r;

        _px = hv_fetch(point, "x", 1, 0);
        _py = hv_fetch(point, "y", 1, 0);

        _cx = hv_fetch(circle, "x", 1, 0);
        _cy = hv_fetch(circle, "y", 1, 0);
        _r  = hv_fetch(circle, "r", 1, 0);

        if (!(_px && _py && _cx && _cy && _r))
        {
            croak ("One of the arguments is NULL");
        }

        px = SvNV(*_px);
        py = SvNV(*_py);

        cx = SvNV(*_cx);
        cy = SvNV(*_cy);
        r  = SvNV(*_r);

        PUSHs(sv_2mortal(newSVnv(_distance_p2c(px, py, cx, cy, r))));

double
circle_area(r_circle)
    SV *r_circle
    PPCODE:
        double cx, cy, r;
        if(!(SvOK(r_circle) && SvROK(r_circle)))
        {
            croak("Circle have to be hashrefs!");
        }
        SV *_circle = SvRV(r_circle);
        if (SvTYPE(_circle) != SVt_PVHV)
        {
            croak("Circle have to be hashrefs!");
        }
        HV *circle = (HV*)_circle;
        if (!(hv_exists(circle, "x", 1) && hv_exists(circle, "y", 1) && hv_exists(circle, "r", 1)))
        {
            croak("Circle hasn't x or y or r field!");
        }
        SV **_cx, **_cy, **_r;

        _cx = hv_fetch(circle, "x", 1, 0);
        _cy = hv_fetch(circle, "y", 1, 0);
        _r  = hv_fetch(circle, "r", 1, 0);

        if (!(_cx && _cy && _r))
        {
            croak ("One of the arguments is NULL");
        }

        
        cx = SvNV(*_cx);
        cy = SvNV(*_cy);
        r  = SvNV(*_r);
        
        PUSHs(sv_2mortal(newSVnv(M_PI * r * r)));