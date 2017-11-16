package App::cccl {

  use strict;
  use warnings;
  use 5.026;
  use experimental qw( signatures );

  # ABSTRACT: Wrapper for cl to make it work like cc
  # VERSION
  
  sub main ($, @args)
  {
    my $cl = App::cccl::cl->new;
  
    foreach my $arg (@args)
    {
      if($arg =~ /^-/)
      {
        # treat as option
        if($arg eq '--version')
        {
          say STDERR "App::cccl version @{[ $App::cccl::VERSION // 'dev' ]}";
          say STDERR $cl->about;
          return 0;
        }
        else
        {
          say STDERR "unknown option: $arg";
          return 1;
        }
      }
      else
      {
        # treat as file
      }
    }
  
    return 0;
  }

}

package App::cccl::cl {

  use Moo;
  use 5.026;
  use experimental qw( signatures );
  use File::Which qw( which );
  use Capture::Tiny qw( capture );
  
  has exe => (
    is      => 'ro',
    default => sub {
      which($ENV{CCCL_CL} // 'cl');
    },
  );
  
  sub about ($self)
  {
    if($self->exe)
    {
      my(undef, $stderr) = capture { system $self->Exe }; 
      return 
        "CL=@{[ $self->exe ]}\n" .
        "$stderr";
    }
    else
    {
      return 'CL not found.';
    }
  }

}

1;
