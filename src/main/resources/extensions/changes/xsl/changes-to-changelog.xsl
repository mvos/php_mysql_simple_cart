<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:changes="http://maven.apache.org/changes/1.0.0">

    <xsl:output standalone="yes" method="text" />

    <xsl:include href="rst.xsl" />

    <xsl:param name="changes.project.name" select="'example.com'" />

    <xsl:variable name="nl">
        <xsl:text>
</xsl:text>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="*" />
    </xsl:template>

    <xsl:template match="changes:properties">
        <!-- -->
    </xsl:template>

    <xsl:template match="changes:document">
        <xsl:apply-templates select="*" />
    </xsl:template>

    <xsl:template match="changes:body">
        <xsl:apply-templates select="*">
            <xsl:sort select="@date" order="descending" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="changes:release">
        <xsl:variable name="release.title">
            <xsl:apply-templates select="." mode="release-title" />
        </xsl:variable>

        <xsl:value-of select="$release.title" />
        <xsl:value-of select="$nl" />

        <xsl:call-template name="line">
            <xsl:with-param name="length" select="string-length($release.title)" />
        </xsl:call-template>
        <xsl:value-of select="$nl" />
        <xsl:value-of select="$nl" />

        <xsl:if test="@description">
            <xsl:call-template name="wrap-string">
                <xsl:with-param name="string" select="normalize-space(@description)" />
            </xsl:call-template>
            <xsl:value-of select="$nl" />
        </xsl:if>

        <xsl:apply-templates select="*[@type = 'fix']" mode="action-fix" />
        <xsl:apply-templates select="*[@type != 'fix']" mode="action-feature" />
        <xsl:if test="count(*[@type]) &gt; 0">
            <xsl:value-of select="$nl" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="changes:action" mode="action-fix">
        <xsl:apply-templates select=".">
            <xsl:with-param name="action" select="'Fixed'" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="changes:action" mode="action-feature">
        <xsl:apply-templates select=".">
            <xsl:with-param name="action" select="'Implemented'" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="changes:action">
        <xsl:param name="action" select="''" />

        <xsl:call-template name="wrap-string">
            <xsl:with-param name="string">
                <xsl:call-template name="generate-action-text">
                    <xsl:with-param name="action" select="$action" />
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="indent" select="'  '" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generate-action-text">
        <xsl:param name="action" select="''" />

        <xsl:text>- </xsl:text>
        <xsl:if test="@issue">
            <xsl:value-of select="$action" />
            <xsl:text> #</xsl:text>
            <xsl:value-of select="@issue" />
            <xsl:text>: </xsl:text>
        </xsl:if>

        <xsl:value-of select="normalize-space(text())" />
        <xsl:if test="@date">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$action" />
            <xsl:text> in commit #</xsl:text>
            <xsl:value-of select="@date" />
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="changes:release" mode="release-title">
        <xsl:value-of select="$changes.project.name" />
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@version" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@date" />
        <xsl:text>)</xsl:text>
    </xsl:template>

</xsl:stylesheet>
