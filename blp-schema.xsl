<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="xhtml"/>
    
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <xsl:template match="/">
        <html>
            <head>
                <style>
                    .blk {
                        border-left: 3px dashed silver;
                        margin: 10px 5px 10px 10px;
                    
                        padding-left: 10px;
                        display: inline-block;
                    }
                    .paramtbl {
                        /*border: 1px solid rgba(0, 0, 0, 0.1);*/
                        border-collapse: collapse;
                        margin: 5px 5px 5px 20px;
                        width:95%;
                        box-sizing: border-box;
                    }
                    .paramtbl thead td {
                     
                        background-color: rgba(0, 0, 0, 0.3);
                    }
                    
                    .paramtbl  td {
                        border: 1px solid rgba(0, 0, 0, 0.7);
                        padding: 6px;
                        transition: 0.5s background-color linear;
                    }
                    .paramtbl  td:hover {
                        background-color: rgba(30, 30, 230, 0.05);
                        transition: 0.5s background-color linear;
                    }
                    .fieldname {
                        background-color: yellow;
                        padding-left: 30px;
                        font-weight: bold;
                        font-style: italic;
                    }
                    .fieldtype{
                        border: 2px dashed silver;
                        background-color: rgba(60,60,255,0.2)
                    }
                </style>
            </head>
        </html>
        <body>
            <xsl:apply-templates select="./ServiceDefinition/service"/>
        </body>
    </xsl:template>
    <xsl:template match="/ServiceDefinition/service">

        <h1> Service: <xsl:value-of select="../@name"/>
            (<xsl:value-of select="./@name"/>)
        </h1>

        <h2>Operations:</h2>
        <xsl:apply-templates select="./operation"/>


        <h2>Events:</h2>
        <xsl:apply-templates select="./event"/>

    </xsl:template>
    <xsl:template match="//operation">
        <h3>
            <xsl:value-of select="@name"/>
        </h3> Request: <br/>
        <xsl:variable name="rqType" select="translate(string(./requestSelection),$lowercase,$uppercase)"/>
        <xsl:variable name="rqType2" select="translate(string(./request),$lowercase,$uppercase)"/>
        <xsl:apply-templates select="/ServiceDefinition/schema/sequenceType[translate(@name,$lowercase,$uppercase) = $rqType or translate(@name,$lowercase,$uppercase) = $rqType2]"/>
        <xsl:apply-templates select="/ServiceDefinition/schema/choiceType[translate(@name,$lowercase,$uppercase) = $rqType or translate(@name,$lowercase,$uppercase) = $rqType2]"/>
        
        <br/> Response: <br/>
        <xsl:variable name="rsType" select="translate(string(./responseSelection),$lowercase,$uppercase)"/>
        <xsl:variable name="rsType2" select="translate(string(./response),$lowercase,$uppercase)"/>
        <xsl:apply-templates select="/ServiceDefinition/schema/sequenceType[translate(@name, $lowercase,$uppercase) = $rsType or translate(@name, $lowercase,$uppercase) = $rsType2]"/>
        <xsl:apply-templates select="/ServiceDefinition/schema/choiceType[translate(@name,$lowercase,$uppercase) = $rqType or translate(@name,$lowercase,$uppercase) = $rqType2]"/>
    </xsl:template>
    <xsl:template match="//event">
        <h3>
            <xsl:value-of select="@name"/>
        </h3> Response: <br/>
        <xsl:variable name="eventType" select="translate(string(./@eventType),$lowercase,$uppercase)"/>
        <xsl:apply-templates select="/ServiceDefinition/schema/sequenceType[translate(@name, $lowercase,$uppercase) = $eventType]"/>
        <br/>
    </xsl:template>
   
    <xsl:template match="//element">
        <tr>
            <td class="fieldname">

                <xsl:value-of select="./@name"/>
                <xsl:if test="string-length(./@id) &gt; 0"> (field #<xsl:value-of select="./@id"/>) </xsl:if>

            </td>
            <td>
                <xsl:value-of select="./@type"/>
            </td>
            <td>
                <xsl:if
                    test="string-length(./@minOccurs)!=0 and string-length(./maxOccurs)!=0 ">
                    <xsl:value-of select="./@minOccurs"/>...<xsl:value-of select="./@maxOccurs"/>
                </xsl:if>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <blockquote color="gray">
                    <pre><xsl:value-of select="./description"/></pre>
                </blockquote>
                <xsl:variable name="typeName" select="string(@type)"/>
                <xsl:apply-templates select="//schema/enumerationType[@name = $typeName]"/>
                <xsl:apply-templates select="//schema/sequenceType[@name = $typeName]"/>
                <xsl:apply-templates select="//schema/choiceType[@name = $typeName]"/>
                
            </td>
        </tr>

    </xsl:template>
    
    
    <xsl:template match="//enumerationType">
        <br/>
        <b>Enum: </b><xsl:value-of select="@name"/>(<xsl:value-of select="@type"/>)<br/>
        <ul>
            <xsl:for-each select="./enumerator">
                <li>
                    <xsl:value-of select="@name"/>
                    <xsl:if test="string(@name) != string(./value/*/text())"> = <xsl:value-of
                            select="./value/*/text()"/>
                    </xsl:if>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="//sequenceType">
        
        <table class="paramtbl">
            <thead>
                <tr>
                    <td>Field</td>
                    <td>Type</td>
                    <td>Cardinality</td>
                </tr>
            </thead>
            
            <xsl:apply-templates select="./element"/>
            
        </table>
    </xsl:template>
    
    
    <xsl:template match="//choiceType">
        <h4 class="fieldtype">Choice of:</h4>
        <table class="paramtbl">
            <thead>
                <tr>
                    <td>Field</td>
                    <td>Type</td>
                    <td>Cardinality</td>
                </tr>
            </thead>
            
            <xsl:apply-templates select="./element"/>
            
        </table>
        
       
    </xsl:template>

</xsl:stylesheet>
