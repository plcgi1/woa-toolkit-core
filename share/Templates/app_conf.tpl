app_root        = [%app_root%]
app_name        = [%app_name%]
app_version     = 0.1
log_dir         = $app_root/log
template_root   = $app_root/templates

connect_info = dbi:mysql:dbname=blabla
connect_info = root

<session>
    expires = 864000
    storage = $app_root/run/app.session
</session>

<static>
    dirs $app_root/public
    dirs $app_root/public
    include_path $app_root/public
    include_path $app_root/public
</static>

<log4perl>
    log4perl.category =  DEBUG, Logfile

    log4perl.appender.Logfile           = Log::Dispatch::FileRotate
    log4perl.appender.Logfile.filename  =  $log_dir/[%app_name%].log
    log4perl.appender.Logfile.mode      =  append
    log4perl.appender.Logfile.layout    =  PatternLayout
    log4perl.appender.Logfile.max       =  2
    log4perl.appender.Logfile.size      =  10_000_000
    log4perl.appender.Logfile.layout.ConversionPattern =  "[%d] [%p] - %m // %c:%L%n"

    log4perl.logger.main                            = DEBUG
</log4perl>