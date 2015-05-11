
 use strict;
 use Parse::RecDescent;
 use Data::Dumper;

 use vars qw(%VARIABLE);

 # Enable warnings within the Parse::RecDescent module.

 $::RD_ERRORS = 1; # Make sure the parser dies when it encounters an error
 $::RD_WARN   = 1; # Enable warnings. This will warn on unused rules &c.
 $::RD_HINT   = 1; # Give out hints to help fix problems.

 my $grammar = <<'_EOGRAMMAR_';

   # Terminals (macros that can't expand further)
   #

   OP       : m([-+*/%])      # Mathematical operators
   INTEGER  : /[-+]?\d+/      # Signed integers
   VARIABLE : /\w[a-z0-9_]*/i # Variable

   expression : INTEGER OP expression
              { return main::expression(@item) }
              | VARIABLE OP expression
              { return main::expression(@item) }
              | INTEGER
              | VARIABLE
              { return $main::VARIABLE{$item{VARIABLE}} }

   print_instruction  : /print/i expression
                      { print $item{expression}."\n" }
   assign_instruction : VARIABLE "=" expression
                      { $main::VARIABLE{$item{VARIABLE}} = $item{expression} }

   instruction : print_instruction
               | assign_instruction

   startrule: instruction(s /;/)

_EOGRAMMAR_

 sub expression {
   shift;
   my ($lhs,$op,$rhs) = @_;
   $lhs = $VARIABLE{$lhs} if $lhs=~/[^-+0-9]/;
   return eval "$lhs $op $rhs";
 }

 my $parser = Parse::RecDescent->new($grammar);

my @res = $parser->startrule("a=1-2+3");
print Dumper(\@res);