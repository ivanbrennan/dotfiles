use ExtUtils::MakeMaker;

WriteMakefile(
    NAME      => "flaccurate",
    VERSION   => "1.0"
    EXE_FILES => [ "bin/flaccurate" ]
    PREREQ_PM => { "LWP" => 0, "Carp" => 0, "POSIX" => 0 }
);
