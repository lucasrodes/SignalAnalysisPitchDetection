---------------------------------------------------------------------
Evaluation of Pitch Detection (F0)

Antonio Bonafonte
UPC, Barcelona
2015
---------------------------------------------------------------------

To evaluate the pitch detection algorithms, we provide a
labeled base data and a program for calculating error metrics.

-------------------------
1. Database.
-------------------------

The database to be used is:
Fundamental Frequency Determination Algorithm (FDA) Evaluation Database.

Centre for Speech Technology Research
University of Edinburgh
80 South Bridge
Edinburgh EH1 1HN
U.K.

It was obtained from
http://www.cstr.ed.ac.uk/research/projects/fda/fda_eval.tar.gz

You can view the original for more information on the database
and additional data (glotograph, programs, etc.)

The original database includes audio files (20k, 16bit)
and a file with the f0 contour obtained from a second
file that contains the output of a laryngograph. This apparatus
measures impedance between the sensors that are connected to both sides of the
larynx, whereby the contour obtained can be used as a reference.

We have made a change in format, so that our audio files are in
.wav format (instead of raw format), and f0 contours of Reference (.f0ref) are interpolated
every 15 milliseconds.


-------------------------
2. Detection of Pitch
-------------------------

For each .wav file, your program should output a text file with extension
.f0 and a line every 15 milliseconds, indicating the fundamental frequency
in Hz. If the segment is unvoiced, you must write a line with a ’0’.

To test your program with all the .wav files in the database you can use a 
script in bash. For example, edit and adapt the script run_getpitch.sh


-------------------------
3. Evaluation
-------------------------

Once you have all the files with the detected pitch, (extension .f0),
which must be in the same directory as the reference files (extension
.f0ref), you can execute the pitch_compare program to evaluate your 
method.

After compiling the program:
g ++ -o pitch_compare.cpp pitch_compare
you execute it with the list of .f0ref to consider in the evaluation.

For example:
./pitch_compare pitch_db/rl*.f0ref (Female Voice)
./pitch_compare pitch_db/sb*.f0ref (Female Voice)
./pitch_compare pitch_db/*.f0ref (BOTH MALE & FEMALE)

This program calculates, for each file:

* Voiced frames -> unvoiced (1 - recall voiced)
  Number of unvoiced frames that have been erroneously classified as voiced.

* Unvoiced frames -> voiced: (1 - recall unvoiced)
  Number of voiced frames that have been erroneously classified as unvoiced.

* Gross voiced errors:
  In voiced frames, detected as voiced,
  Pitch errors greater than 20%

* MSE of fine errors:
  In voiced frames, detected as voiced with an error less than 20%,
  the average of that error. (Mean Squared Error)
  (In the summary, the average is over all files)

