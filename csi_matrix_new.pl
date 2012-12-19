#! /usr/bin/perl

#*********************************************************************************************
#
#Written by Alos Diallo, Walhout Lab
#This program will take in a matrix an generate a csi matrix as a result.
#For any position on the matrix Aij where i = rows and j= columns 
#evaluate the following: Aij -c <= max value of (Ait, Atj) until t = k.  
#For example if Ait = .5 and Atj = .8 the max value is .8
#If the evaluation is true add 1 to value positive then evaluate Cij = 1 - (positive/k).
#Once you have done that greate a new matrix filled with Cij values.  
#
#*********************************************************************************************
use strict;
use warnings;
use POSIX;
use Data::Dumper;
use List::Util qw(min max);
use POSIX qw(ceil);
use File::Basename;

sub csi_matrix ($) {
my $input_matrix = shift;
my $constant = .05;


open (MATRIX, $input_matrix) or die $!;
my ($i,$j,$m,$l,$size,$w,$max_value,$value,$score,$line,@main_2D_array,@row_array,@csi_score,@value);
$i=$j=$m=$l=$size=$w=$max_value=$value=$score=$line = 0;
 

while($line = <MATRIX>){               
    chomp($line); 
    @row_array = split(/\t/, $line);
    $j=0;
    foreach my $element (@row_array){
		$main_2D_array[$i][$j++] = $element;
    }
    $i++;
}
$size = scalar @row_array;

for($l=0; $l<$size; $l++){
	for($m=0; $m<$size; $m++){
		$score = 0;
		for($w =0; $w <$size; $w++){
			my $column_walk = $main_2D_array[$l][$w];
			my $row_walk = $main_2D_array[$w][$m];
			$value[0] = $column_walk;
			$value[1] = $row_walk;
			$max_value = max(@value);
			if(($main_2D_array[$l][$m] - $constant) <= $max_value){
				$score++;
			}
		}
		$csi_score[$l][$m] = 1 - ($score/$size);
	}
}
	return(\@csi_score,$size);
close (MATRIX);

}


sub feeder(){
	my @array_list;
	my @solution;
	my $sol_ref = 0;
	my $size = 0;
	my $m = 0;
	my $l;
	my $input_matrix = $ARGV[0];
	my $input_matrix_random = $ARGV[1];
	my @matrix;
	my @name;
	my @temp;
	my @jobid_num;
	my $w = 0;
	my $element = 0;
	$matrix[0]= $input_matrix;
	$name[0]= "$input_matrix";
	$matrix[1]= $input_matrix_random;
	$name[1]= "$input_matrix_random";
	my $x = 0;

	my $file_info = dirname($input_matrix);
	
	my @jobid_ref = split( /\//, $file_info);
	my $jobid_size = 0;
	$jobid_size= scalar (@jobid_ref - 1);
	@jobid_num = split( /_/, $jobid_ref[$jobid_size]);
	
	for ($x = 0; $x < 2;$x++){
		my $holder = $matrix[$x];
		open(OUT,">".$file_info."/"."csi_result_".$x.".txt");
		($sol_ref,$size)=&csi_matrix($holder);
		@solution = @$sol_ref;
		for($l=0; $l<$size; $l++){
			for($m=0; $m<$size; $m++){

				print OUT "$solution[$l][$m]\t";
			}

			print OUT"\n";			
		}
		
	
			my $myTri = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/triangle_gen.r /$file_info/csi_result_0.txt $file_info`;
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
		
		open(LIST,">".$file_info."/"."csi_list_".$x.".txt");
		for($l=0; $l<$size; $l++){
			for($m=0; $m<$size; $m++){
				my $place_holder = 'TRUE ';
				if($triangle[$l][$m] eq $place_holder){
					$temp[$p] = $solution[$l][$m]; 
					print LIST"$solution[$l][$m]\t";
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
	open(CSISTAT,">>"."/home/dialloa/nearline/index_results"."/"."csi_stats".".".$jobid_num[1]."."."txt");
	my @Tcount = ($arraySizeN, $arraySizeR);
	my $arrayMin = min(@Tcount);
	
	my $percent = ($countO / $arrayMin) * 100;
	print CSISTAT "$percent\t";

	my $spear = `/share/bin/R-2.14.1/bin/Rscript /home/dialloa/bin/spear.r /$file_info/csi_list_0.txt /$file_info/csi_list_1.txt`;
	chomp $spear;
	my @collection =  split(/\n/, $spear);
	my $CSize = scalar (@collection);
	my $count = 0;
	for($count = 0;$count < $CSize;$count++){

		print CSISTAT "$collection[$count]\t";
	}
	print CSISTAT "\n";
	
	close CSISTAT;
}
	
	

&feeder;