Bloomberg Schemas
===

You can download the Bloomberg API schema downloader(SchemaDownloader_64.exe) from bloomberg at https://bcms.bloomberg.com/BLPAPI-Generic/

The output of the application is schema files in a custom bloomberg schema format(not to be confused by XSD Xml Schema - BLP Schema is a custom format).

Use the attached blp-schema.xsl to transform the .xsd files to .html. Any XSLTv1 engine should work, such as xsltproc.

```
SchemaDownloader_64.exe -file schema-apiflds.xml -s apifields

xsltproc -o schema-apiflds.html blp-schema.xsl schema-apiflds.xml
```

The processed HTMLs are available at:

http://altmind.github.io/blp-schemas/schema-apiflds.html

http://altmind.github.io/blp-schemas/schema-instruments.html

http://altmind.github.io/blp-schemas/schema-mktbar.html

http://altmind.github.io/blp-schemas/schema-mktdata.html

http://altmind.github.io/blp-schemas/schema-mktlist.html

http://altmind.github.io/blp-schemas/schema-mktvwap.html

http://altmind.github.io/blp-schemas/schema-pagedata.html

http://altmind.github.io/blp-schemas/schema-refdata.html

http://altmind.github.io/blp-schemas/schema-srcref.html

http://altmind.github.io/blp-schemas/schema-tasvc.html


SchemaDownloader Readme
===

`SchemaDownloader` is a standalone tool that is used for obtaining a blpapi service schema for mocking blpapi events.
It is a statically linked binary that supports Linux and Windows operating systems for both 32 and 64 bits.

Usage
---


```
        [-zfp-over-leased-line <port>   enable ZFP connections over leased lines on the specified port (8194 or 8196) (default: 8194)
        [-auth <option>]                authentication option (default: user):
                none
                user                     as a user using OS logon information
                dir=<property>           as a user using directory services
                app=<app>                as the specified application
                userapp=<app>            as user and application using logon information
                                         for the user
                manual=<app>,<ip>,<user> as user and application, with manually provided
                                         IP address and EMRS user
        [-ip   <ipAddress>]            server name or IP (default: localhost)
        [-p    <tcpPort>]              server port (default: 8194)
        [-s    <service>]              service name for schema download
        [-file <outputFile>]           output file name (default: schema.xsd))
TLS OPTIONS (specify all):
        [-tls-client-credentials <file>]         name a PKCS#12 file to use as a source of client credentials
        [-tls-client-credentials-password <pwd>] specify password for accessing client credentials
        [-tls-trust-material <file>]             name a PKCS#7 file to use as a source of trusted certificates
        [-read-certificate-files]                (optional) read the TLS files and pass the blobs
```

**Note** that `-zfp-over-leased-line` cannot be used in conjunction with `-ip` and/or  `-p`.
