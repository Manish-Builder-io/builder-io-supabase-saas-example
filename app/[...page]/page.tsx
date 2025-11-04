// Example file structure, app/[...page]/page.tsx
// You could alternatively use src/app/[...page]/page.tsx

import { builder } from "@builder.io/sdk";
import { RenderBuilderContent } from "../../components/builder";
import { Metadata } from "next";

// Replace with your Public API Key
const apiKey = process.env.NEXT_PUBLIC_BUILDER_API_KEY || '';

if (apiKey) {
  builder.init(apiKey);
}

interface PageProps {
  params: {
    page: string[];
  };
}

export async function generateMetadata(props: PageProps): Promise<Metadata> {
  const urlPath = "/" + (props?.params?.page?.join("/") || "");
  
  if (!apiKey) {
    return {
      title: 'Builder.io Page',
    };
  }

  try {
    const content = await builder
      .get("page", {
        userAttributes: {
          urlPath,
        },
        prerender: false,
      })
      .toPromise();

    if (content) {
      return {
        title: content.data?.title || 'Builder.io Page',
        description: content.data?.description || undefined,
      };
    }
  } catch (error) {
    console.error('Error fetching metadata:', error);
  }

  return {
    title: 'Builder.io Page',
  };
}

export default async function Page(props: PageProps) {
  const model = "page";
  
  if (!apiKey) {
    return (
      <div className="flex items-center justify-center min-h-screen p-8">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Builder.io API Key Missing</h1>
          <p className="text-gray-600 mb-4">
            Please set NEXT_PUBLIC_BUILDER_API_KEY in your .env file
          </p>
        </div>
      </div>
    );
  }

  const content = await builder
    // Get the page content from Builder with the specified options
    .get("page", {
      fetchOptions: { next: { revalidate: 5 } },
      userAttributes: {
        // Use the page path specified in the URL to fetch the content
        urlPath: "/" + (props?.params?.page?.join("/") || ""),
      },
      // Set prerender to false to return JSON instead of HTML
      prerender: false,
    })
    // Convert the result to a promise
    .toPromise();

  return (
    <>
      {/* Render the Builder page */}
      <RenderBuilderContent content={content} model={model} />
    </>
  );
}

