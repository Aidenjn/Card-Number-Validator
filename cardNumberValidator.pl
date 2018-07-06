#Author: Aiden Nelson
#Date: 7/2/2018
#Description: Reads in a file of card numbers and then outputs them to a file with pass/fail numbers.
#0 if card number is correct length and passes Luhn
#1 if card number is correct length and does not pass Luhn
#2 if card number is incorrect length (Luhn does not matter)

use strict;
use warnings;

open(my $inputFile, "<", @ARGV) or die "Can't open ", @ARGV, ": $!";	# Open file given as argument
my $outputFile = "card_summary.txt";	# Create output file.
unless(open OUTPUT, ">".$outputFile) {
	die "Cannot create card_summary.txt: $!";
}

#open(my $outputFile, ">", "card_summary.txt" or die "Cannot create card_summary.txt: $!";

while (<$inputFile>) {	# Assigns next line to $_ each iteration
	chomp($_);
	print OUTPUT "$_\t\t", code_decider($_);
	if (code_decider($_) == 1) {
		print OUTPUT "\t\t REVISION: ", get_correct_number($_);
	}
	print OUTPUT "\n";
}

close OUTPUT;


#Decides which code to assign to the given card number.
sub code_decider {
	my $number = shift;
	if (!is_correct_length($number)) {
		return 2;
	}
	return luhm($number);
}

#Checks to see if the card number is the correct length.
#Returns 1 if correct length, otherwise returns 0.
sub is_correct_length {
	my $number = shift;
	my @digits = $number =~ /\d{1}/g;
	if ((@digits == 15) && ($digits[0] == 3)) {	# Pass if first digit is 3 and number is 15 digits long.
		return 1;
	}
	elsif (@digits == 16) {	# Otherwise pass if card is 16 digits.
		return 1;
	}
	return 0;
}	

#Luhms Algorithm implemented as a perl subroutine. 
sub luhm {
	my $sum = 0;
	my $number = shift;	
	my @digits = $number =~ /\d{1}/g;	# Split number into an array of digits.
	my $checkDigit = pop @digits;		# Copy last digit.
	@digits = reverse @digits;			# Reverse order of digits.
	for (my $i = 0; $i < @digits; $i++) {	# Apply step 1 of algorithm.
		if ($i % 2 == 0) {
			$digits[$i] *= 2;
			if ($digits[$i] > 9) {
				$digits[$i] -= 9;
			}
		}
		$sum += $digits[$i];
	}
	if (($sum * 9) % 10 != $checkDigit) {	# Pass if the calculated check digit does not match the original last digit.
		return 1;
	}
	return 0;
}

#Find the proper number according to Luhms Algorithm. 
sub get_correct_number {
	my $sum = 0;
	my $number = shift;	
	my @digits = $number =~ /\d{1}/g;	# Split number into an array of digits.
	my $checkDigit = pop @digits;		# Copy last digit.
	@digits = reverse @digits;			# Reverse order of digits.
	for (my $i = 0; $i < @digits; $i++) {	# Apply step 1 of algorithm.
		if ($i % 2 == 0) {
			$digits[$i] *= 2;
			if ($digits[$i] > 9) {
				$digits[$i] -= 9;
			}
		}
		$sum += $digits[$i];
	}
	my @returnNum = $number =~ /\d{1}/g;	# Create another digit array.
	pop @returnNum;							# Remove last digit.
	push @returnNum, (($sum * 9) % 10);		# Add correct ending digit.
	return (@returnNum);
}