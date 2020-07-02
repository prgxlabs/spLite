import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="spLite",
    version="0.0.3",
    author="Michael Stackhouse",
    author_email="michaelstackhouse0614@gmail.com",
    description="A lightweight Python module to interface with the SharePoint REST API for the basic function of uploading and downloading files",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/mstackhouse/spLite",
    packages=setuptools.find_packages(),
    package_data={ 'spLite' : [ 'SAML.xml' ] },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    install_requires=[
        'requests-ntlm>=1.1.0',
    ],
    python_requires='>=3.6',
)
