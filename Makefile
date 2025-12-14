.PHONY: verify #build shell clean

IMAGE := env.sif
DEF := env.def
CHECK_INSTALL := ./scripts/check_and_install_singularity.sh
CHECK_ENVIRONMENT := ./scripts/check_and_build_singularity_image.sh

# Common verification
verify:
	@echo "🔍 Verifying installation & environment..."

	@sh -c $(CHECK_INSTALL) --check >/dev/null && \
		(echo "✅ Singularity is already installed.") || \
		( \
			echo "⚠️ Singularity is not installed. Installing..." && \
			sudo $(CHECK_INSTALL) --install >/dev/null && \
			echo "✅ Successfully installed Singularity."; \
			exit 0; \
		)

	@sh -c $(CHECK_ENVIRONMENT) --check >/dev/null \
		&& (echo "✅ A SIF image is already built.") \
		|| ( \
				echo "⚠️ No SIF image found. Building..." && \
				sudo $(CHECK_ENVIRONMENT) --build >/dev/null && \
				echo "✅ Successfully built a SIF image."; \
				exit 0; \
			)

# # Build Singularity image
# build: verify
# 	@echo "📦 Building Singularity image..."
# 	sudo singularity build $(IMAGE) $(DEF)

# # Open a shell inside the image
# shell: verify
# 	@echo "🐚 Entering container shell..."
# 	singularity shell $(IMAGE)

# # Cleanup
# clean: verify
# 	@echo "🧹 Cleaning up..."
# 	rm -f $(IMAGE)