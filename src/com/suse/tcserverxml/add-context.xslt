<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="path" />
    <xsl:param name="docBase" />
    <xsl:param name="contextXml" />

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Host[@name='localhost'and Context[@path=$path]]">
        <xsl:copy>
            <!-- Update existing Context -->
            <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="updateContext">true</xsl:with-param>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Host[@name='localhost' and not(Context[@path=$path])]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <!-- Add new Context -->
            <xsl:call-template name="add_context"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Context">
        <xsl:param name="setPathDocBase"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="$setPathDocBase='true'">
                <xsl:attribute name="path"><xsl:value-of select="$path"/></xsl:attribute>
                <xsl:attribute name="docBase"><xsl:value-of select="$docBase"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Context[@path=$path]">
        <xsl:param name="updateContext"/>
        <xsl:choose>
            <xsl:when test="$updateContext='true'">
                <xsl:call-template name="add_context"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="add_context">
        <xsl:choose>
            <xsl:when test="not($contextXml)">
                <xsl:call-template name="add_simple_context"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($contextXml)/Context">
                    <xsl:with-param name="setPathDocBase">true</xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="add_simple_context">
        <Context path="{$path}" docBase="{$docBase}">
            <Resources allowLinking="true" />
        </Context>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

</xsl:stylesheet>

