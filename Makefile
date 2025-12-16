.PHONY: setup challenge_009

IMAGE := env.sif
CHECK_INSTALL := ./scripts/check_and_install_singularity.sh
CHECK_ENVIRONMENT := ./scripts/check_and_build_singularity_image.sh

# Common verification
setup:
	@echo "🔍 Verifying installation & environment..."

	@sh -c $(CHECK_INSTALL) --check >/dev/null && \
		(echo "✅ Singularity is already installed.") || \
		( \
			echo "⚠️ Singularity is not installed. Installing..." && \
			sudo $(CHECK_INSTALL) --install >/dev/null && \
			echo "✅ Successfully installed Singularity."; \
			exit 0; \
		)

	@sh -c $(CHECK_ENVIRONMENT) --check >/dev/null && \
		(echo "✅ A SIF image is already built.") || \
		( \
			echo "⚠️ No SIF image found. Building..." && \
			sudo $(CHECK_ENVIRONMENT) --build >/dev/null && \
			echo "✅ Successfully built a SIF image."; \
			exit 0; \
		)

# Cleanup singularity image
clean:
	@echo "🧹 Cleaning up..."
	@read -p "Are you sure you want to remove $(IMAGE)? [y/N] " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		rm -f $(IMAGE); \
		echo "✅ Removed $(IMAGE)"; \
	else \
		echo "❌ Cleanup cancelled."; \
	fi

# Open a shell inside the image
shell: verify
	@echo "🐚 Entering container shell..."
	singularity shell $(IMAGE)

# Build Singularity image
challenge_009: setup
	@echo "🚀 Running exercise 2..."
	singularity run $(IMAGE) ./challenge_009/HelloWorld.java