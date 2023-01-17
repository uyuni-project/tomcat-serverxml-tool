A simple tool to add/remove tags and elements from/to the `server.xml` file of a Tomcat server.

Call `tomcat-serverxml-tool.sh` with arguments for help

## Example
```
./serverxml-tool.sh add-context.xslt docBase=%{tomcatappdir}/host-manager path=/host-manager contextXml=%{tomcatappdir}/host-manager/META-INF/context.xml
```
where:
- `add-context.xslt` is an xslt file in `src/com/suse/tcserverxml/`
- `docBase`, `path` and `contextXml` are the parameters in `add-context.xslt`
