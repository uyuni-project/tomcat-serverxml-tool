#!/bin/bash

JAR=/usr/lib/tomcat/serverxmltool.jar
SERVERXML=/etc/tomcat/server.xml

function usage {
    echo "Usage: tomcat-serverxml-tool.sh file.xslt [arg=value]..."
    echo "Example: https://github.com/uyuni-project/tomcat-serverxml-tool/blob/example/README.md#example"
}

if [[ -z "$1" ]]; then
    usage
    exit 1
fi

XSLT="$1"
ATTRIBUTE="${@:2}"

SUFIX=$(date +%H%M%S%N)
rm -f ${SERVERXML}.new${SUFIX} ${SERVERXML}.old${SUFIX}

/usr/bin/java -jar $JAR $XSLT $SERVERXML $ATTRIBUTE > ${SERVERXML}.new${SUFIX}

if [ $? -eq 0 ]; then
    mv $SERVERXML ${SERVERXML}.old${SUFIX}
    mv ${SERVERXML}.new${SUFIX} $SERVERXML
    rm ${SERVERXML}.old${SUFIX}
    if [[ -z "$ATTRIBUTE" ]]; then
        echo "Use $XSLT with no attribute"
    else        
        echo "Use $XSLT with attribute $ATTRIBUTE"
    fi
else
    echo "$SERVERXML was not modified."
    rm ${SERVERXML}.new${SUFIX}
    exit 2
fi
