#! /usr/bin/perl

#*********************************************************************************************
#
# Written by Alos Diallo, Walhout Lab
# This program will take in a matrix and generate a random matrix as a result.
#
# Requirments 
#	Perl, R,  
#	Perl packages warnings, strict, List::Util qw(min max)	
# References
# 	
#	http://stat.ethz.ch/R-manual/R-patched/library/base/html/matmult.html
#*********************************************************************************************
use warnings;
use strict;
use List::Util qw(min max);
use File::Basename; 

sub toy_matrix(){
my $matrix_name = $ARGV[0];
my $pn = 0;
my $amount_to_add_1  = $ARGV[1];
#my $amount_to_add  = 10;
my $pn_1 = 1;
my $amount_to_add  = $ARGV[2];
#my $amount_to_add_1  = 5;
#$amount_to_add_1 = int($amount_to_add_1);

	open TOY, "$matrix_name" or die $!;
#	system("rm -rf list.txt");
	my ($line,$i,$k,$j,$element,$w,$l,$n);
	my (@main_2D_array,@row_array,@holder_number_zero,@holder_coord_zero,@holder_number_one,@holder_coord_one);
	$line=$i=$k=$j=$element=$w=$l=$n= 0;
	while($line = <TOY>){ 
		# Chop off new line character, skip the comments and empty lines.                 
		chomp($line); 
		@row_array = split(/\t/, $line);
	   $j=0;
		foreach $element (@row_array){
			$main_2D_array[$i][$j++] =$element;
		}
		$i++;
	}

	for($l=0; $l<$i; $l++){
		for($w=0; $w<@row_array; $w++){
			if($main_2D_array[$l][$w] == 0){
				$holder_number_zero[$k] = 0;
				$holder_coord_zero[$k] = $l."|".$w; 
				$k++;
			}			
			if($main_2D_array[$l][$w] == 1){
				$holder_number_one[$n] = 1;
				$holder_coord_one[$n] = $l."|".$w; 
				$n++;
			}	
		}
	}

	my $file_info = dirname($matrix_name);
	
	open(LISTZERO,">".$file_info."/"."list.txt");
	open(LISTTWO,">".$file_info."/"."list_two.txt");
	open(RESULTS,">".$file_info."/"."result_random.txt");
	
	for($l=0; $l<$k; $l++){	
		print LISTZERO "$holder_number_zero[$l]\t";	
		#print "$holder_number_zero[$l]\t";	
	}
	for($l=0; $l<$n; $l++){	
		print LISTTWO "$holder_number_one[$l]\t";	
		
	}
	
	

	my $myPval = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/random.r $file_info $amount_to_add $pn_1`;
	my $myPval_1 = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/random_two.r $file_info $amount_to_add_1 $pn`;
	
	chomp $myPval;
	chomp $myPval_1;	

	my $z = 0;

	$myPval =~ s/\[1\]\s+//; 
	$myPval_1 =~ s/\[1\]\s+//; 
	my @new_random =  split(/ /, $myPval);
	my @new_random_one =  split(/ /, $myPval_1);

	for($l=0; $l<@holder_number_zero; $l++){
		my ($y,$x) = split(/\|/,$holder_coord_zero[$l]);

		if($new_random[$l] == $pn_1){
			$main_2D_array[$y][$x] = $new_random[$l];
			#print "\n$new_random[$l]\n";
		}
		#print "\n";
	}
	for($l=0; $l<@holder_number_one; $l++){
		my ($y,$x) = split(/\|/,$holder_coord_one[$l]);
		if($new_random_one[$l] == $pn){
			$main_2D_array[$y][$x] = $new_random_one[$l];
			#print "\n$new_random_one[$l]\n";
		}
	}
	


	for($l=0; $l<$i; $l++){
		for($w=0; $w<@row_array; $w++){
			print RESULTS "$main_2D_array[$l][$w]\t";
			#print "$main_2D_array[$l][$w]\t";
		}
		print RESULTS "\n";
		#print "\n";
	}
	
	close (TOY);
	close (LISTZERO);
	close (RESULTS);
	return(\@main_2D_array,\@row_array,$i);
}

my ($matrixTwoD,$row_array,$i);
($matrixTwoD,$row_array,$i)=&toy_matrix();
my @main_2D_array = @$matrixTwoD;
my @row_array = @$row_array;



