use strict;
use English;


my %hash=();
my $plate_home = "/home/dialloa/nearline/index_results";
my $home_base = "/home/dialloa/";
my $line = 0;
chdir $plate_home;
my @file_name;
my @initialImages = <*>;
#chdir $home_base;
open(OUTCSI,">>"."CSI_Results.txt");
open(OUTHYPER,">>"."HYPER_Results.txt");
open(OUTGEO,">>"."GEO_Results.txt");
open(OUTMM,">>"."MM_Results.txt");
open(OUTPEAR,">>"."PEAR_Results.txt");
open(OUTJAC,">>"."JAC_Results.txt");
open(OUTCOS,">>"."COS_Results.txt");

foreach my $file (@initialImages) {
    if($file =~ /csi_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){                
			chomp($line);
			print OUTCSI "$file_name[1]\t$line\n";

		}				
	}
	elsif($file =~ /geo_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){                
			chomp($line);
			print OUTGEO "$file_name[1]\t$line\n";
		}		
		
	}
	elsif($file =~ /c_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){                
			chomp($line);
			print OUTCOS "$file_name[1]\t$line\n";
		}		
	
	}
	elsif($file =~ /hyper_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){ 	
			chomp($line);
			print OUTHYPER "$file_name[1]\t$line\n";
		}		
			
	}
	elsif($file =~ /jaccard_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){                
			chomp($line);
			print OUTJAC "$file_name[1]\t$line\n";
		}
	}
			
	elsif($file =~ /mm_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){                
			chomp($line);
			print OUTMM "$file_name[1]\t$line\n";
		}
	}
	elsif($file =~ /pearson_stats*/){
		@file_name = split /\./, $file;
		open RESULTS, $file or die $!;
		while($line = <RESULTS>){                
			chomp($line);
			my @row_array = split(/\t/, $line);
			my $host = $row_array[7];
			my $command  = 0;
			print OUTPEAR "$file_name[1]\t$line\n";
			$command = `ssh $host "rm -rf /dev/shm/jobid_*"`;
			
		}
	}
		

}




close OUTCSI;
close OUTPEAR;
close OUTMM;
close OUTJAC;
close OUTHYPER;
close OUTGEO;
close RESULTS;