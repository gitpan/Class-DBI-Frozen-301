use Class::DBI::Frozen::301;
use strict;
use Test::More;

BEGIN {
	eval "use DBD::SQLite";
	plan $@ ? (skip_all => 'needs DBD::SQLite for testing') : (tests => 5);
}

INIT {
	use lib 't/testlib';
	require Film;
	require Order;
	Order->CONSTRUCT;
	Film->CONSTRUCT;
}

Film->has_many(orders => 'Order');
Order->has_a(film => 'Film');

my $film = Film->retrieve('Bad Taste');
isa_ok $film => 'Film';

$film->add_to_orders({ orders => 10 });

my $bto = Order->search(film => 'Bad Taste')->first;
isa_ok $bto => 'Order';
is $bto->orders, 10, "Correct number of orders";


my $infilm = $bto->film;
isa_ok $infilm, "Film";

is $infilm->id, $film->id, "Orders hasa Film";
