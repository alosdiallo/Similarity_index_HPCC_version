#! /usr/bin/perl

#*********************************************************************************************
#
# Written by Alos Diallo, Walhout Lab
# This program will take in a matrix an generate a pearson matrix as a result.
#
# Requirments 
#	Perl, R,  
#	Perl packages warnings, strict, List::Util qw(min max)	
# References
# 	
#	http://stat.ethz.ch/R-manual/R-patched/library/base/html/matmult.html
#*********************************************************************************************
use strict;
use warnings;
use POSIX;
use Data::Dumper;
use List::Util qw(min max);
use POSIX qw(ceil);
use File::Basename;
#use Sort::Rank qw(rank_sort);
use Sys::Hostname;


sub toy_matrix($){
my $matrix_name = shift;

	my $file_info = dirname($matrix_name);
	open TOY, "$matrix_name" or die $!;

	my $myPval = 0;
	my ($line,$i,$k,$j,$element,$l,$w,$holder);
	my (@main_2D_array,@row_array,@pears,@parent);
	$holder = "@";
	$line=$i=$k=$j=$element= 0;
	my $size = 0;
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
			$holder = "$holder\t$main_2D_array[$l][$w]";
		}
		$holder = (split(/@/, $holder))[1];
		$parent[$l] = $holder;
		$holder = "@";
	}
	
	for($l=0; $l<$i; $l++){
		$k = $parent[$l];
		for($w=0; $w<$i; $w++){
			open(ONE,">".$file_info."/"."one.txt");
			open(TWO,">".$file_info."/"."two.txt");
			$j = $parent[$w];
			print ONE "$k";
			print TWO "$j";
			 $myPval = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/pears.r /$file_info/one.txt /$file_info/two.txt`;
			 chomp $myPval;
			 $pears[$l][$w] = (split(/\s+/, $myPval))[1];

		}
	
	}
	return(\@pears,$l,$w);

}

sub feeder($$$){
	my @solution;
	my @temp;
	my @array_list;
	my $sol_ref = 0;
	my $size = 0;
	my $m = 0;
	my $l = 0;
	my $i = 0;
	my $w = 0;
	my $input_matrix = $ARGV[0];
	my $input_matrix_random = $ARGV[1];
	my @matrix;
	my @name;
	my @jobid_num;		
	my $element = 0;
	$matrix[0]= $input_matrix;
	$name[0]= "$input_matrix";
	$matrix[1]= $input_matrix_random;
	$name[1]= "$input_matrix_random";

	my $file_info = dirname($input_matrix);
	my @jobid_ref = split( /\//, $file_info);
	my $jobid_size = 0;
	$jobid_size= scalar (@jobid_ref - 1);
	@jobid_num = split( /_/, $jobid_ref[$jobid_size]);		
	my $x = 0;
	for ($x = 0; $x < 2;$x++){
		my $holder = $matrix[$x];
		open(OUT,">".$file_info."/"."pearson_".$x.".txt");

		($sol_ref,$i,$w)=&toy_matrix($holder);

		@solution = @$sol_ref;
		for($l=0; $l<$i; $l++){
			for($m=0; $m<$w; $m++){
				print OUT "$solution[$l][$m]\t";

			}
			print OUT "\n";

			
		}

			my $myTri = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/triangle_gen.r /$file_info/pearson_0.txt $file_info`;
			chomp $myTri;
			my $p = 0;
			my $line = 0;
			my @triangle;
			my $z = 0;
			my $y = 0;
			
			open TRIANGLE, "/$file_info/triangle.txt" or die $!;

			while($line = <TRIANGLE>){ 
				# Chop off new line character, skip the comments and empty lines.                 
				chomp($line); 

				my @row_array = split(/\t/, $line);
			   $z=0;
				foreach $element (@row_array){
					$triangle[$y][$z++] = $element;

				}
				$y++;
			}
			close TRIANGLE;

			
		open(LIST,">".$file_info."/"."pearson_list_".$x.".txt");
			for($l=0; $l<$i; $l++){
				for($m=0; $m<$w; $m++){
					my $place_holder = 'TRUE ';
					if($triangle[$l][$m] eq $place_holder){
						$temp[$p] = $solution[$l][$m]; 
						print LIST "$solution[$l][$m]\t";
						$p++;

					}
					
				}
			}
			
			

			my @temp_sorted = sort{$b <=> $a} @temp;
			my $ten = (scalar @temp_sorted) * .1;
			#$ten = ceil($ten);


			$w = 0;
			my $count = 0;
			my @watch;
			for($count = 0;$count <$p;$count++){
				if($temp[$count] >= $temp_sorted[$ten]){

					$watch[$w] = $count;
					#print"$watch[$w]\t$x\n";
					$w++;
				}
			}
			
			
			# for($count = 0;$count <$w;$count++){
				# print"$watch[$count]\t$x\n";
			# }

			
			$array_list[$x] = \@watch;
			#print Dumper(@array_list);
			# print Dumper($x);

			close OUT;
			close LIST;
		
	}
	
	#print Dumper(@array_list);
	my $norm_ref = $array_list[0];
	my @norm = @{$norm_ref};
	
	my $rand_ref = $array_list[1];
	my @rand = @{$rand_ref};
	
	
	@norm = sort{$a <=> $b} @norm;
	@rand = sort{$a <=> $b} @rand;

	my $arraySizeN = scalar (@norm);
	my $arraySizeR = scalar (@rand);
	#print "$arraySizeN\t$arraySizeR\n";
	
	my $countO = 0;
	my $countN = 0; 
	my $countR = 0;	
	for($countN = 0;$countN < $arraySizeN;$countN++){
	
		for($countR = 0;$countR < $arraySizeR;$countR++){
			if($norm[$countN] == $rand[$countR]){
				$countO++;
			}
		
		}
		
	}

    my $host = hostname;
	open(CSISTAT,">>"."/home/dialloa/nearline/index_results"."/"."pearson_stats".".".$jobid_num[1]."."."txt");
	my @Tcount = ($arraySizeN, $arraySizeR);
	my $arrayMin = min(@Tcount);
	
	my $percent = ($countO / $arrayMin) * 100;
	print CSISTAT "$percent\t";

	my $spear = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/spear.r /$file_info/pearson_list_0.txt /$file_info/pearson_list_1.txt`;
	chomp $spear;
	my @collection =  split(/\n/, $spear);
	my $CSize = scalar (@collection);
	my $count = 0;
	for($count = 0;$count < $CSize;$count++){

		print CSISTAT "$collection[$count]\t";
	}
	print CSISTAT "$host";
	print CSISTAT "\n";
	
	close CSISTAT;
close OUT;
}
&feeder;

close (TOY);
close (ONE);
close (TWO);
