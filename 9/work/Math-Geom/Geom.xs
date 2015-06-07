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

void test(int x)
{
    printf("%d\n", x);
}

MODULE = Math::Geom		PACKAGE = Math::Geom		

void
MMC(r_A)
    SV *r_A
    CODE:
        SSize_t len = av_top_index((AV *)SvRV(r_A));




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