/*
 * This file was generated automatically by ExtUtils::ParseXS version 3.24 from the
 * contents of Geom.xs. Do not edit this file, edit Geom.xs instead.
 *
 *    ANY CHANGES MADE HERE WILL BE LOST!
 *
 */

#line 1 "Geom.xs"
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

#line 40 "Geom.c"
#ifndef PERL_UNUSED_VAR
#  define PERL_UNUSED_VAR(var) if (0) var = var
#endif

#ifndef dVAR
#  define dVAR		dNOOP
#endif


/* This stuff is not part of the API! You have been warned. */
#ifndef PERL_VERSION_DECIMAL
#  define PERL_VERSION_DECIMAL(r,v,s) (r*1000000 + v*1000 + s)
#endif
#ifndef PERL_DECIMAL_VERSION
#  define PERL_DECIMAL_VERSION \
	  PERL_VERSION_DECIMAL(PERL_REVISION,PERL_VERSION,PERL_SUBVERSION)
#endif
#ifndef PERL_VERSION_GE
#  define PERL_VERSION_GE(r,v,s) \
	  (PERL_DECIMAL_VERSION >= PERL_VERSION_DECIMAL(r,v,s))
#endif
#ifndef PERL_VERSION_LE
#  define PERL_VERSION_LE(r,v,s) \
	  (PERL_DECIMAL_VERSION <= PERL_VERSION_DECIMAL(r,v,s))
#endif

/* XS_INTERNAL is the explicit static-linkage variant of the default
 * XS macro.
 *
 * XS_EXTERNAL is the same as XS_INTERNAL except it does not include
 * "STATIC", ie. it exports XSUB symbols. You probably don't want that
 * for anything but the BOOT XSUB.
 *
 * See XSUB.h in core!
 */


/* TODO: This might be compatible further back than 5.10.0. */
#if PERL_VERSION_GE(5, 10, 0) && PERL_VERSION_LE(5, 15, 1)
#  undef XS_EXTERNAL
#  undef XS_INTERNAL
#  if defined(__CYGWIN__) && defined(USE_DYNAMIC_LOADING)
#    define XS_EXTERNAL(name) __declspec(dllexport) XSPROTO(name)
#    define XS_INTERNAL(name) STATIC XSPROTO(name)
#  endif
#  if defined(__SYMBIAN32__)
#    define XS_EXTERNAL(name) EXPORT_C XSPROTO(name)
#    define XS_INTERNAL(name) EXPORT_C STATIC XSPROTO(name)
#  endif
#  ifndef XS_EXTERNAL
#    if defined(HASATTRIBUTE_UNUSED) && !defined(__cplusplus)
#      define XS_EXTERNAL(name) void name(pTHX_ CV* cv __attribute__unused__)
#      define XS_INTERNAL(name) STATIC void name(pTHX_ CV* cv __attribute__unused__)
#    else
#      ifdef __cplusplus
#        define XS_EXTERNAL(name) extern "C" XSPROTO(name)
#        define XS_INTERNAL(name) static XSPROTO(name)
#      else
#        define XS_EXTERNAL(name) XSPROTO(name)
#        define XS_INTERNAL(name) STATIC XSPROTO(name)
#      endif
#    endif
#  endif
#endif

/* perl >= 5.10.0 && perl <= 5.15.1 */


/* The XS_EXTERNAL macro is used for functions that must not be static
 * like the boot XSUB of a module. If perl didn't have an XS_EXTERNAL
 * macro defined, the best we can do is assume XS is the same.
 * Dito for XS_INTERNAL.
 */
#ifndef XS_EXTERNAL
#  define XS_EXTERNAL(name) XS(name)
#endif
#ifndef XS_INTERNAL
#  define XS_INTERNAL(name) XS(name)
#endif

/* Now, finally, after all this mess, we want an ExtUtils::ParseXS
 * internal macro that we're free to redefine for varying linkage due
 * to the EXPORT_XSUB_SYMBOLS XS keyword. This is internal, use
 * XS_EXTERNAL(name) or XS_INTERNAL(name) in your code if you need to!
 */

#undef XS_EUPXS
#if defined(PERL_EUPXS_ALWAYS_EXPORT)
#  define XS_EUPXS(name) XS_EXTERNAL(name)
#else
   /* default to internal */
#  define XS_EUPXS(name) XS_INTERNAL(name)
#endif

#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE
#define PERL_ARGS_ASSERT_CROAK_XS_USAGE assert(cv); assert(params)

/* prototype to pass -Wmissing-prototypes */
STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params);

STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params)
{
    const GV *const gv = CvGV(cv);

    PERL_ARGS_ASSERT_CROAK_XS_USAGE;

    if (gv) {
        const char *const gvname = GvNAME(gv);
        const HV *const stash = GvSTASH(gv);
        const char *const hvname = stash ? HvNAME(stash) : NULL;

        if (hvname)
            Perl_croak(aTHX_ "Usage: %s::%s(%s)", hvname, gvname, params);
        else
            Perl_croak(aTHX_ "Usage: %s(%s)", gvname, params);
    } else {
        /* Pants. I don't think that it should be possible to get here. */
        Perl_croak(aTHX_ "Usage: CODE(0x%"UVxf")(%s)", PTR2UV(cv), params);
    }
}
#undef  PERL_ARGS_ASSERT_CROAK_XS_USAGE

#ifdef PERL_IMPLICIT_CONTEXT
#define croak_xs_usage(a,b)    S_croak_xs_usage(aTHX_ a,b)
#else
#define croak_xs_usage        S_croak_xs_usage
#endif

#endif

/* NOTE: the prototype of newXSproto() is different in versions of perls,
 * so we define a portable version of newXSproto()
 */
#ifdef newXS_flags
#define newXSproto_portable(name, c_impl, file, proto) newXS_flags(name, c_impl, file, proto, 0)
#else
#define newXSproto_portable(name, c_impl, file, proto) (PL_Sv=(SV*)newXS(name, c_impl, file), sv_setpv(PL_Sv, proto), (CV*)PL_Sv)
#endif /* !defined(newXS_flags) */

#line 182 "Geom.c"

XS_EUPXS(XS_Math__Geom_MMC); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Math__Geom_MMC)
{
    dVAR; dXSARGS;
    if (items != 2)
       croak_xs_usage(cv,  "r_A, r_B");
    {
	SV *	r_A = ST(0)
;
	SV *	r_B = ST(1)
;
	SV *	RETVAL;
#line 37 "Geom.xs"
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
#line 261 "Geom.c"
	ST(0) = RETVAL;
	sv_2mortal(ST(0));
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Math__Geom_distance_p2c); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Math__Geom_distance_p2c)
{
    dVAR; dXSARGS;
    if (items != 2)
       croak_xs_usage(cv,  "r_point, r_circle");
    PERL_UNUSED_VAR(ax); /* -Wall */
    SP -= items;
    {
	SV *	r_point = ST(0)
;
	SV *	r_circle = ST(1)
;
	double	RETVAL;
	dXSTARG;
#line 115 "Geom.xs"
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
#line 328 "Geom.c"
	PUTBACK;
	return;
    }
}


XS_EUPXS(XS_Math__Geom_circle_area); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Math__Geom_circle_area)
{
    dVAR; dXSARGS;
    if (items != 1)
       croak_xs_usage(cv,  "r_circle");
    PERL_UNUSED_VAR(ax); /* -Wall */
    SP -= items;
    {
	SV *	r_circle = ST(0)
;
	double	RETVAL;
	dXSTARG;
#line 163 "Geom.xs"
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
#line 381 "Geom.c"
	PUTBACK;
	return;
    }
}

#ifdef __cplusplus
extern "C"
#endif
XS_EXTERNAL(boot_Math__Geom); /* prototype to pass -Wmissing-prototypes */
XS_EXTERNAL(boot_Math__Geom)
{
    dVAR; dXSARGS;
#if (PERL_REVISION == 5 && PERL_VERSION < 9)
    char* file = __FILE__;
#else
    const char* file = __FILE__;
#endif

    PERL_UNUSED_VAR(cv); /* -W */
    PERL_UNUSED_VAR(items); /* -W */
#ifdef XS_APIVERSION_BOOTCHECK
    XS_APIVERSION_BOOTCHECK;
#endif
    XS_VERSION_BOOTCHECK;

        newXS("Math::Geom::MMC", XS_Math__Geom_MMC, file);
        newXS("Math::Geom::distance_p2c", XS_Math__Geom_distance_p2c, file);
        newXS("Math::Geom::circle_area", XS_Math__Geom_circle_area, file);
#if (PERL_REVISION == 5 && PERL_VERSION >= 9)
  if (PL_unitcheckav)
       call_list(PL_scopestack_ix, PL_unitcheckav);
#endif
    XSRETURN_YES;
}

