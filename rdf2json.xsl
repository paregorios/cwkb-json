<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:lawd="http://lawd.info/ontology/" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:output encoding="UTF-8" byte-order-mark="no"  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="dictionary">
            <j:map>
                <xsl:call-template name="metadata"/>
                <xsl:apply-templates select="rdf:RDF"/>
            </j:map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($dictionary, map{'indent':true()})"/>
        <xsl:apply-templates select="//rdf:RDF/rdf:Description[contains(@rdf:about, 'work')]" mode="orphan"/>
    </xsl:template>
    
    <xsl:template match="rdf:RDF">
        <j:array key="authors">
            <xsl:apply-templates select="rdf:Description[contains(@rdf:about, 'author')]"/>            
        </j:array>
    </xsl:template>
    
    <xsl:template match="rdf:Description" mode="orphan">
        <xsl:variable name="this" select="@rdf:about"/>
        <xsl:if test="count(//rdf:Description[contains(@rdf:about, 'author') and lawd:responsibleFor[@rdf:resource=$this]]) = 0">
            <xsl:message>orphan work: <xsl:value-of select="$this"/></xsl:message>            
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="rdf:Description[rdf:type[@rdf:resource='http://xmlns.com/foaf/0.1/Person']]">
        <xsl:variable name="author_id" select="tokenize(@rdf:about, '/')[6]"/>
        <j:map>
            <j:string key="id"><xsl:value-of select="$author_id"/></j:string>
            <xsl:if test="lawd:abbreviation">
                <j:array key="abbreviations">
                    <xsl:apply-templates select="lawd:abbreviation"/>
                </j:array>
            </xsl:if>
            <xsl:if test="rdfs:label">
                <j:array key="names">
                    <xsl:apply-templates select="rdfs:label"/>
                </j:array>
            </xsl:if>
            <xsl:if test="dcterms:identifier|owl:sameAs">
                <j:array key="identifiers">
                    <xsl:apply-templates select="dcterms:identifier"/>
                    <xsl:apply-templates select="owl:sameAs"/>                    
                </j:array>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="lawd:responsibleFor">
                    <j:array key="works">
                        <xsl:apply-templates select="lawd:responsibleFor"/>
                    </j:array>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>No work associated with author <xsl:value-of select="@rdf:about"/></xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </j:map>
    </xsl:template>
    
    <xsl:template match="lawd:responsibleFor">
        <xsl:variable name="target" select="@rdf:resource"/>
        <xsl:apply-templates select="//*[@rdf:about=$target]"/>
    </xsl:template>
    
    <xsl:template match="rdf:Description">
        <xsl:variable name="work_id" select="tokenize(@rdf:about, '/')[6]"/>
        <j:map>
            <j:string key="id"><xsl:value-of select="$work_id"/></j:string>
            <xsl:if test="lawd:abbreviation">
                <j:array key="abbreviations">
                    <xsl:apply-templates select="lawd:abbreviation"/>
                </j:array>
            </xsl:if>
            <xsl:if test="rdfs:label">
                <j:array key="titles">
                    <xsl:apply-templates select="rdfs:label"/>
                </j:array>
            </xsl:if>
            <xsl:if test="dcterms:identifier|owl:sameAs">
                <j:array key="identifiers">
                    <xsl:apply-templates select="dcterms:identifier"/>
                    <xsl:apply-templates select="owl:sameAs"/>
                </j:array>
            </xsl:if>
            <xsl:if test="dcterms:language">
                <j:array key="languages">
                    <xsl:apply-templates select="dcterms:language"/>
                </j:array>
            </xsl:if>
        </j:map>
    </xsl:template>
    
    <xsl:template match="rdfs:label">
        <xsl:variable name="key">
            <xsl:choose>
                <xsl:when test="../rdf:type[@rdf:resource='http://xmlns.com/foaf/0.1/Person']">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>title</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <j:map>
            <j:string key="{$key}"><xsl:apply-templates select="text()"/></j:string>
            <xsl:if test="@xml:lang">
                <j:string key="lang"><xsl:value-of select="@xml:lang"/></j:string>
            </xsl:if>
        </j:map>
    </xsl:template>
    
    <xsl:template match="dcterms:identifier" mode="woo">
        <xsl:message>woot</xsl:message>
        <xsl:text></xsl:text><xsl:apply-templates select="text()"/><xsl:text></xsl:text>
    </xsl:template>
    
    <xsl:template match="lawd:abbreviation|dcterms:identifier|dcterms:language">
        <j:string><xsl:apply-templates select="text()"/></j:string>
    </xsl:template>
    
    <xsl:template match="owl:sameAs[contains(@rdf:resource, 'data.perseus.org/catalog/urn:cts:')]">
        <xsl:variable name="identifier" select="substring-after(@rdf:resource, 'data.perseus.org/catalog/')"/>
        <xsl:if test="not(../dcterms:identifier[contains(., $identifier)])">
            <j:string><xsl:apply-templates select="$identifier"/></j:string>    
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:text></xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text></xsl:text>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:message><xsl:value-of select="name()"/></xsl:message>
    </xsl:template>
    
    <xsl:template name="metadata">
        <j:map key="metadata">
            <j:string key="namespace">http://dublincore.org/documents/dcmi-terms/</j:string>
            <j:string key="title">Classical Works Knowledge Base in JSON</j:string>
            <j:string key="source">http://cwkb.org/allrecords/rdf</j:string>
            <j:string key="type">dataset</j:string>
            <j:string key="format">application/json</j:string>
            <xsl:variable name="abstract">All authors and works identified in the CWKB Linked Data
                release, arranged hierarchically into a list of authors, each with a subordinate
                "works" list, all serialized into JavaScript Object Notation (JSON) format. Keys for
                authors and works make use of the unique identifying numbers found in the original
                CWKB RDF (e.g., where CWBK assigns an identifier like
                "http://cwkb.org/work/id/7960/rdf", the key value "7960" appears in the appropriate
                JSON object in the "works" array). Alternate names and abbreviations for authors, as
                well as titles and abbreviations for works, have also been replicated, as have
                external identifiers used by the Perseus Digital Library, the Packard Humanities
                Institute's online Latin texts, etc. The purpose of this JSON serialization is to
                facilitate use of the CWKB in web applications and other environments.
            </xsl:variable>
            <j:string key="abstract"><xsl:value-of select="normalize-space($abstract)"/></j:string>
            <j:array key="creators">
                <j:map>
                    <j:string key="name">Eric Rebillard</j:string>
                </j:map>
                <j:map>
                    <j:string key="name">Adam Chandler</j:string>
                </j:map>
                <j:map>
                    <j:string key="name">David Ruddy</j:string>
                </j:map>
            </j:array>
            <j:array key="contributors">
                <j:map>
                    <j:string key="name">Tom Elliott</j:string>
                    <j:string key="role">converted data to JSON from RDF/XML</j:string>
                </j:map>
            </j:array>
            <j:string key="modified">
                <xsl:value-of select="current-dateTime()"/>
            </j:string>
            <xsl:variable name="license">Noncommercial, educational, charitable, and scholarly users may
                use, reproduce or display all or part of the CWKB for teaching or scholarly
                purposes; on a projection, computer or television screen; in classroom materials; or
                in other scholarly or teaching devices without incurring a publication or usage
                fee.</xsl:variable>
            <j:string key="license"><xsl:value-of select="normalize-space($license)"/></j:string>
        </j:map>
    </xsl:template>
</xsl:stylesheet>