use strict;
use warnings;

use Local::OK::Topic;

use feature 'say';

use open ':std', ':encoding(UTF-8)';

# my $group = Local::OK::Group->new (
#     'http://ok.ru/group/54129200201728'
# );
# my $group = Local::OK::Group->new (
#     'http://ok.ru/goodfood'
# );
my $topic = Local::OK::Topic->new (
    'http://ok.ru/goodfood/topic/66791673176064/'
);


say $topic->id;
say $topic->text; 
say $topic->group->url;
say $topic->group->name;
say $topic->group->id;

# say $topic->content;
# say $topic->group->content;
