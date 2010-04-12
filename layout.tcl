source [file join [file dirname [info script]] tclrivet.tcl]

proc getlayout {filehandle} {
    if { ! [info exists ::layout] } {
	set fl [open layout.rvt]
	set ::layout [read $fl]
	close $fl
    }
    tclrivetparser::setoutputcmd [list puts -nonewline $filehandle]
    set layoutparsed [tclrivetparser::parserivetdata $::layout]
    return $layoutparsed
}

proc render {filename} {
    set htmlfile [file rootname $filename].html
    set htmlfileexists [file exists $htmlfile]
    if { $htmlfileexists } {
	set htmlmtime [file mtime $htmlfile]
	set rvtmtime [file mtime $filename]
	set layoutmtime [file mtime layout.rvt]
    }

    if { $htmlfileexists && $htmlmtime > $rvtmtime && $htmlmtime > $layoutmtime} {
	puts "$htmlfile up to date"
	return
    }

    puts -nonewline "Processing $filename ..."

    namespace eval page {}
    set ::page::obuffer ""
    tclrivetparser::setoutputcmd { append ::page::obuffer }
    namespace eval page [list rivet $filename]

    set ofile [open $htmlfile w]

    proc contents {} [list namespace eval page [list puts -nonewline $ofile $::page::obuffer]]

    namespace eval page [getlayout $ofile]
    close $ofile

    namespace delete page
    puts "done"
}

proc all {} {
    foreach fl [glob *.rvt] {
	if { $fl eq "layout.rvt" } { continue }

	render $fl
    }
}

proc clean {} {
    foreach fl [glob *.rvt] {
	if { $fl eq "layout.rvt" } { continue }

	file delete "[file rootname $fl].html"
    }
}

eval [lindex $argv 0]
