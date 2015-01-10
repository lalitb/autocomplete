#!/usr/bin/perl
package Trie;
use Data::Dumper;

my $node = {
	mMarker => 0 ,
	mContent => "",
	mChildren => []
};

my $root={};

sub addWord {
   my $s = shift;
   my $cur = $root;
   if (length($s) == 0) {
	$cur->{mMarker} = 1;
        return;
   }
   foreach my $c (split //, $s) {
	 #find child
	my $found = 0;
	foreach ( @{$cur->{mChildren}}) {
		if ( $_->{mContent} eq lc $c ) {
		    $cur = $_;
		    $found = 1;
		    last;
		}
	 }
         unless ($found) {
	#	print "\n A_dding new node for $c";
		my $tmp ;
		$tmp->{mContent} = lc $c;
		push @{$cur->{mChildren}}, $tmp;
		$cur = $tmp;
		#print "\n After adding:".Dumper($root);
	 }
   }
   $cur->{mMarker} = 1;
	#print "Dump:".Dumper($root);
}

sub searchWord {
    my $s = shift;
    my $cur = $root;
 #   while ( $cur ) {
      foreach my $c ( split // , $s)  {
	 my $found = 0;
	 foreach ( @{$cur->{mChildren}}) {
	    #print "\n Comparing $_->{mContent} and $c";
	    if ($_->{mContent} eq lc $c ) {
		$cur = $_;
		$found = 1;
		last;
	    }
	 }
	 return 0 unless ($found);
      }
      if ($cur->{mMarker} ) {
	return 1;
      } else {
	return 0;
      }
  #  }
  #  return 0;
}

sub getAllWords {

    my ($cur, $str, $res ) = @_;
    return  unless(scalar @{$cur->{mChildren}}); 
    foreach (@{$cur->{mChildren}}) {
	if ($_->{mMarker}) {
	   push @$res, $str.$_->{mContent};
	}
	getAllWords($_, $str.$_->{mContent}, $res);
    }
}

sub searchWordsWithPrefix {
    my $result = [];
    my $s = shift;
    my $cur = $root;
    foreach my $c ( split // , $s) {
	my $found = 0;
	foreach (@{$cur->{mChildren}}) {
          if (lc $_->{mContent} eq lc $c) {
	     $cur = $_;
	     $found = 1;
	     last;
          }
       }
       return [] unless ($found); 
    }
    getAllWords($cur, $s, $result);
    return $result;
}

=cut
package main;
use Data::Dumper;
open CITIES, "cities.txt";
foreach (<CITIES>) {
    chomp($_);
    Trie::addWord($_);
}
print Dumper(Trie::searchWordsWithPrefix("de"));
Trie::addWord("abc");
Trie::addWord("abcd");
Trie::addWord("abcdd");
Trie::addWord("asss");
print "\n".Trie::searchWord("abc");
print "\n".Trie::searchWord("abcs");
print "\n".Trie::searchWord("ab");
print "\n".Dumper(Trie::searchWordsWithPrefix("ab"));

