import { useRouter } from "next/router";
export default function Home() {
  const router = useRouter();
  return (
    <div>
      
      <button className="px-6 py-2 w-40 rounded-full bg-red-500 text-white" onClick={() => router.push("/employee")}>Employee</button>
      <button className="px-6 py-2 w-40 rounded-full bg-blue-500 text-white" onClick={() => router.push("/public")}>Public</button>
    </div>
  );
}
