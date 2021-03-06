#' Plot Mapped Reads
#'
#' @name plotMappedReads
#' @family Quality Control Functions
#' @author Michael Steinbaugh, Rory Kirchner, Victor Barrera
#'
#' @inheritParams general
#'
#' @return `ggplot`.
#'
#' @examples
#' plotMappedReads(bcb_small)
NULL



# Methods ======================================================================
#' @rdname plotMappedReads
#' @export
setMethod(
    "plotMappedReads",
    signature("bcbioRNASeq"),
    function(
        object,
        interestingGroups,
        limit = 10L,
        fill = NULL,
        flip = TRUE,
        title = "mapped reads"
    ) {
        validObject(object)
        if (missing(interestingGroups)) {
            interestingGroups <- bcbioBase::interestingGroups(object)
        } else {
            interestingGroups(object) <- interestingGroups
        }
        assertIsAnImplicitInteger(limit)
        assert_all_are_non_negative(limit)
        assertIsFillScaleDiscreteOrNULL(fill)
        assert_is_a_bool(flip)
        assertIsAStringOrNULL(title)

        p <- ggplot(
            data = metrics(object),
            mapping = aes_(
                x = ~sampleName,
                y = ~mappedReads / 1e6L,
                fill = ~interestingGroups
            )
        ) +
            geom_bar(
                color = "black",
                stat = "identity"
            ) +
            labs(
                title = title,
                x = NULL,
                y = "mapped reads per million",
                fill = paste(interestingGroups, collapse = ":\n")
            )

        if (is_positive(limit)) {
            p <- p + bcbio_geom_abline(yintercept = limit)
        }

        if (is(fill, "ScaleDiscrete")) {
            p <- p + fill
        }

        if (isTRUE(flip)) {
            p <- p + coord_flip()
        }

        if (identical(interestingGroups, "sampleName")) {
            p <- p + guides(fill = FALSE)
        }

        p
    }
)
