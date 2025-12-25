#ifndef YYSTYPE_HEADER
#define YYSTYPE_HEADER
union KC_YYSTYPE {
    kc::nocasestring yt_nocasestring;
    kc::casestring yt_casestring;
    kc::real yt_real;
    kc::integer yt_integer;
    kc::voidptr yt_voidptr;
    kc::line yt_line;
    kc::term yt_term;
    kc::expression yt_expression;
};
#define YYSTYPE KC_YYSTYPE
#endif // YYSTYPE_HEADER
