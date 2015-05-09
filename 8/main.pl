# OK 1. reg
# OK 2. login
# OK 3. last5
# OK 4. edit
# OK 5. delete
# OK 6. profile
# OK 7. escape scripts

use Dancer2;
use Local::Schema;
use DateTime::Format::MySQL;
use utf8::all;
use feature 'say';
use Dancer::Plugin::EscapeHTML;


set 'session'      => 'Simple';
set 'template'     => 'template_toolkit';
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;
set 'username'     => 'admin';
set 'password'     => 'password';
set 'layout'       => 'main';

my $schema = Local::Schema->connect('dbi:mysql:web', "root", "", {mysql_enable_utf8 => 1});

sub users_rs
{
    return $schema->resultset('User');
}

my $FLASH = "";

sub get_flash
{
    my $msg = $FLASH;
    $FLASH = '';
    return $msg;
}

sub add_flash
{
    $FLASH .= ' '.shift;
}

get '/profile' => sub {
    if (session 'logged_in')
    {
        my $me = users_rs()->find({login => session('login')});
        template('profile.tt', 
            {   
                user => {login => escape_html($me->login), src => escape_html($me->avatar)},
                msg => escape_html(get_flash()),
            }
        );
    }
    else
    {
        return redirect '/login';
    }
};

get '/delete' => sub {
    if (session 'logged_in')
    {
        users_rs()->find({login => session('login')})->delete();
        return redirect '/exit';
    }
    else
    {
        return redirect '/';
    }
};

get '/edit' => sub {
    if (session('logged_in'))
    {
        template('edit.tt', 
            {
                msg => escape_html(get_flash()),
            }
        );
    }
    else
    {
        return redirect '/';
    }
};

post '/edit' => sub {
    if (!session('logged_in'))
    {
        return redirect '/';
    }
    my $login = escape_html(param('login'));
    my $password = escape_html(param('password'));
    my $avatar = escape_html(param('avatar'));
    if (!$login or !$password or !$avatar)
    {
        add_flash("Не все поля заполнены");
        return redirect '/edit';
    }
    if ($login ne session('login') and users_rs()->find({login => $login}))
    {
        add_flash("Логин уже занят :-(");
        return redirect '/edit';
    }
    my $current_user = users_rs()->find({login => session('login')});
    $current_user->update(
        {
            login => $login,
            password => $password,
            avatar => $avatar,
        }
    );
    session 'login' => $login;
    session 'src' => $avatar;
    add_flash('Изменения сохранены');
    return redirect '/profile';
};

get '/' => sub {
    if (session('logged_in'))
    {
        return redirect '/profile';
    }
    else
    {
        return redirect '/login';
    }
};

get '/exit' => sub {
    app->destroy_session;
    return redirect '/';
};

get 'last5' => sub {
    my $users = users_rs()->search(
        {}, 
        {
            order_by => {
                -desc => 'reg_time'
            }, 
            rows => 5
        }
    );
    my $userstt = [];
    while (my $user = $users->next)
    {
        push $userstt, {login => escape_html($user->login), src => escape_html($user->avatar)};
    }
    template 'last5.tt',
    {
        users => escape_html($userstt),
        msg => escape_html(get_flash()),
    }
};

get '/login' => sub {
    if (session('logged_in'))
    {
        return redirect '/profile';
    }
    template("login.tt",
        {
            msg => escape_html(get_flash()),   
        }
    );
};

post '/login' => sub {
    my $login = escape_html(param('login'));
    my $password = escape_html(param('password'));
    if (!$login or !$password)
    {
        add_flash("Не все поля заполнены");
        return redirect '/login';
    }
    my $users = users_rs();
    my $current_user = $users->find({login => $login});
    if (!$current_user)
    {
        add_flash("No such user");
        return redirect '/login';
    }
    else
    {
        if ($current_user->password eq $password)
        {
            session 'logged_in' => true;
            session 'login' => $login;
            session 'src' => $current_user->avatar;
            return redirect '/profile';
        }
        else
        {
            add_flash("Wrong password");
            return redirect '/login';
        }
    }
};

get '/reg' => sub {
    if (session('logged_in'))
    {
        return redirect '/profile';
    }
    template("reg.tt",
        {
            msg => escape_html(get_flash()),   
        }
    );
};

post '/reg' => sub {
    my $login = escape_html(param('login'));
    my $password = escape_html(param('password'));
    if (!$login or !$password)
    {
        add_flash("Не все поля заполнены");
        return redirect '/reg';
    }
    my $users = users_rs();
    my $current_user = $users->find({login => $login});
    if ($current_user)
    {
        add_flash("This login is already taken");
        return redirect '/reg';
    }
    $users->create(
        {
            login => $login,
            reg_time => DateTime::Format::MySQL->format_datetime(
                DateTime::Format::MySQL->parse_datetime(
                    DateTime->now(time_zone => "local")
                )
            ),
            password => $password,
            avatar => 'http://kudago.com/static/img/default-avatar.png'
        }
    );
    session 'logged_in' => true;
    session 'login' => $login;
    session 'src' => 'http://kudago.com/static/img/default-avatar.png';
    return redirect '/profile';
};

start;