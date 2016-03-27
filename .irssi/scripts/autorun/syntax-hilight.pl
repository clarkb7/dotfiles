####################################################################################
# Enables syntax hilighting in sent messages
#
### Tags
# Wrap your code in <$LANG>$CODE</$LANG> to hilight $CODE as if it
# were $LANG code.
#
### Command
# Usage: /code $LANG
# All lines will be parsed as $LANG until $LANG is changed or set to '-'
#
####################################################################################

use strict;
use warnings;
use File::Temp qw(tempfile);

our $VERSION = '0.1';
our %IRSSI = (
    authors     => 'Branden Clark',
    contact     => 'brandenjclark+github@gmail.com',
    name        => 'syntax_hilighter',
    description => 'Enables syntax hilighting in sent messages',
    license     => 'MIT',
);

Irssi::signal_add_first 'send text', 'handle_send_text';
Irssi::command_bind('code', 'handle_code');

# Tool to use for syntax hilighting
# Used in hilight_code
our $hilighter = "pygmentize";
# lexer to use for multiline hilighting
# undefined means no lexing
our $multiline_hilight = undef;

sub hilight_code
{
    my ($processor, $tag, $code) = @_;

    my $hilighted_code;

    # Write code to temporary file
    my ($fh, $filename) = tempfile();
    print $fh $code;

    # Run through hilighter
    if ($processor eq "pygmentize")
    {
        chomp($hilighted_code = `pygmentize -firc -l'$tag' $filename 2>/dev/null`);
    }
    elsif ($processor eq "highlight")
    {
        chomp($hilighted_code = `highlight -Oansi --syntax='$tag' $filename 2>/dev/null`);
    }
    # error in hilighter
    if (${^CHILD_ERROR_NATIVE} != 0) {
        Irssi::print("Hilight command failed!");
        $hilighted_code = "";
    }

    # results
    close $fh;
    unlink($filename);
    return $hilighted_code
}

sub handle_send_text
{
    my ($text, $server, $win_item) = @_;

    if (defined $multiline_hilight)
    {
        # Handle block hilight
        my $hilighted_code = hilight_code($hilighter, $multiline_hilight, $text);
        Irssi::signal_continue($hilighted_code, $server, $win_item);
    }
    elsif ($text =~ /<([a-zA-Z]*)>(.*)<\/\1>/)
    {
        # Handle tag hilight
        my $tag = $1;
        my $code = $2;
        # Hilight code
        my $hilighted_code = hilight_code($hilighter, $tag, $code);
        # Replace inline on success
        if ($hilighted_code ne "")
        {
            $text =~ s/<$tag>\Q$code\E<\/$tag>/$hilighted_code/;
        }
        # Send update
        Irssi::signal_continue($text, $server, $win_item);
    }
}

sub handle_code
{
    my ($data, $server, $win_item) = @_;

    if (!$data) {
        # Print current lexer to status
        if (defined $multiline_hilight) {
            Irssi::print("Current lexer is ".$multiline_hilight);
        }
        else
        {
            Irssi::print("No lexer selected");
        }
    }
    elsif ($data eq "-")
    {
        # Disable syntax hilighting
        undef $multiline_hilight;
    }
    else
    {
        # Enable syntax hilighting for $LANG=$data
        $multiline_hilight = $data;
    }
}
