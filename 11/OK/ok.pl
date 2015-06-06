use strict;
use warnings;
use utf8::all;
use Local::OK::Topic;

use feature 'say';

# my $group = Local::OK::Group->new (
#     'http://ok.ru/group/54129200201728/'
# );
# my $group = Local::OK::Group->new (
#     'http://ok.ru/goodfood'
# );

# say $group->id;
# say $group->name;
# say $group->url;
# say $group->content;





# my $topic = Local::OK::Topic->new (
#     'http://ok.ru/gruppa/topic/62556611955604'
# );
my $topic = Local::OK::Topic->new (
    'http://ok.ru/goodfood/topic/67343230705664'
);

say $topic->id;
say $topic->text; 
say $topic->group->url;
say $topic->group->name;
say $topic->group->id;

# # say $topic->content;
# # say $topic->group->content;
