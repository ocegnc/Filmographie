<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="iso-8859-1" indent="yes" />
    <xsl:template match="/">
        <html>
            <head>
                <script src="https://code.jquery.com/jquery-2.2.4.min.js"> </script>
                <script src="scroll.js"> </script>
                <link rel="stylesheet" type="text/css" href="scroll.css" />
                <link rel="stylesheet" type="text/css" href="film.css" />
                <title> Cinématographie </title>
            </head>
            <body>
                <div id="main">
                    <section>
                        <h1>Table des matières</h1>
                        <table>
                            <tr>
                                <td>
                                    <ul>
                                        <xsl:apply-templates select="films/film" mode="tdm">
                                            <xsl:sort select="@annee" order="descending"
                                                data-type="number" />
                                            <xsl:sort select="exploitation/nbEntrees"
                                                order="ascending"
                                                data-type="number" />
                                        </xsl:apply-templates>
                                    </ul>
                                </td>
                                <td>
                                    <ul>
                                        <xsl:apply-templates select="films/acteurDescription" />
                                    </ul>
                                </td>
                            </tr>
                        </table>
                    </section>
                    <xsl:apply-templates select="films/film" mode="complet">
                        <xsl:sort select="@annee" order="descending" data-type="number" />
                        <xsl:sort select="exploitation/nbEntrees" order="ascending"
                            data-type="number" />
                    </xsl:apply-templates>
                </div>
                <script>
                    $("#main").onepage_scroll({
                    sectionContainer: "section",
                    easing: "ease",
                    animationTime: 1000,
                    pagination: true,
                    updateURL: false,
                    beforeMove: function(index) {},
                    afterMove: function(index) {},
                    loop: false,
                    keyboard: true,
                    responsiveFallback: false
                    });
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="film" mode="tdm">
        <a onClick="$('.main').moveTo({position()+1});">
            <xsl:attribute name="href">#</xsl:attribute>
            <xsl:value-of select="titre/@nom" />
        </a> (<xsl:value-of
            select="count(exploitation/acteurs/acteur)" /> acteurs) [<xsl:for-each
            select="exploitation/scenario/keyword">
            <xsl:value-of select="." />
                        <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        ] <br />
    </xsl:template>

    <xsl:template match="film" mode="complet">
        <section>
            <h2>
                <xsl:if test="@annee=2023">
                    <span style="color: red; font-size: small;">Nouveauté</span>
                </xsl:if>
                <a>
                    <xsl:attribute name="name"><xsl:value-of select="titre/@nom" /></xsl:attribute>
                    <xsl:value-of select="titre/@nom" />
                </a>
            </h2>
            <p>Réalisé par <xsl:value-of select="exploitation/realisateur/@prenom" /><xsl:text> </xsl:text><xsl:value-of
                    select="exploitation/realisateur/@nom" /></p>
            <img class="img">
                <xsl:attribute name="src">
                    <xsl:value-of select="image/@ref" />
                </xsl:attribute>
                <xsl:attribute name="alt">
                    <xsl:value-of select="titre/@nom" />
                </xsl:attribute>
            </img>
            <p>
                <i>Film <xsl:value-of select="@nationalite" /> de <xsl:value-of
                        select="exploitation/duree" />mn sorti en <xsl:value-of select="@annee" /></i>
            </p>
            <p> Genres: <xsl:for-each select="exploitation/genres/genre">
                    <xsl:value-of select="." /> <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </p>
            <p
                class="histoireStyle">
                <xsl:apply-templates select="exploitation/scenario" />
            </p>
            <p>
                <xsl:text>Avec </xsl:text>
                <xsl:for-each select="exploitation/acteurs/acteur">
                    <xsl:value-of select="@prenom" /><xsl:text> </xsl:text><xsl:value-of
                        select="@nom"></xsl:value-of><xsl:if
                        test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </p>
            <br />
        </section>
    </xsl:template>

    <xsl:template match="scenario">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="ev">
        <i>
            <xsl:value-of select="." />
        </i>
    </xsl:template>
    <xsl:template match="perso">
        <b>
            <xsl:value-of select="." />
        </b>
    </xsl:template>

    <xsl:template match="acteur">
        <li>
            <xsl:value-of select="@prenom" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="@nom" />
        </li>
    </xsl:template>

    <xsl:template match="acteurDescription">
        <xsl:variable name="id">
            <ul>
                <xsl:value-of select="@id" />
            </ul>
        </xsl:variable>
        <li>
            <xsl:value-of select="prenom" /><xsl:text> </xsl:text><xsl:value-of select="nom" />, <xsl:value-of
                select="dateNaissance" /> (<xsl:copy-of
                select="count(../film[exploitation/acteurs/acteur/@ref=$id])" /> films) <xsl:for-each
                select="../film[exploitation/acteurs/acteur/@ref=$id]">
                <xsl:variable name="numero"><xsl:number></xsl:number></xsl:variable>
                <a
                    onClick="$('.main').moveTo({$numero+1});">
                    <xsl:attribute name="href">#</xsl:attribute>
                    <xsl:value-of select="position()" />
                </a>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </li>
    </xsl:template>


</xsl:stylesheet>