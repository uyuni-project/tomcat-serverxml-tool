# Archived project
This tool has been deprecated, instead Uyuni now uses `xsltproc` to perform all the changes in server.xml file.
If you want to resume work, please contact us at [GitHub Discussions](https://github.com/uyuni-project/uyuni/discussions) or [the `devel` channel at Gitter](https://gitter.im/uyuni-project/devel)

=====

A simple tool to add/remove tags and elements from/to the `server.xml` file of a Tomcat server.

Call `tomcat-serverxml-tool.sh` without arguments for help

## Example
```
./serverxml-tool.sh add-context.xslt docBase=/usr/share/tomcat/tomcat-webapps/host-manager path=/host-manager contextXml=/usr/share/tomcat/tomcat-webapps/host-manager/META-INF/context.xml
```
where:
- `add-context.xslt` is an xslt file in `src/com/suse/tcserverxml/`
- `docBase`, `path` and `contextXml` are the parameters in `add-context.xslt`
